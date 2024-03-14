#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <curl/curl.h>

#define FILENAME_MAX_LENGTH 256
#define URL_MAX_LENGTH 1024
#define URL_FILE_PATH "$HOME/.url/url.txt"

// Funktion zum Download einer Datei von einer URL
int downloadFile(const char *url, const char *filename) {
    FILE *file = fopen(filename, "wb");
    if (!file) {
        perror("Error opening file");
        return 0;
    }

    CURL *curl = curl_easy_init();
    if (curl) {
        curl_easy_setopt(curl, CURLOPT_URL, url);
        curl_easy_setopt(curl, CURLOPT_WRITEDATA, file);
        CURLcode res = curl_easy_perform(curl);
        curl_easy_cleanup(curl);
        fclose(file);

        if (res != CURLE_OK) {
            remove(filename); // Lösche die Datei, wenn ein Fehler auftritt
            fprintf(stderr, "Error downloading file: %s\n", curl_easy_strerror(res));
            return 0;
        }

        return 1;
    } else {
        fclose(file);
        fprintf(stderr, "Error initializing curl\n");
        return 0;
    }
}

int main(int argc, char *argv[]) {
    // Überprüfen, ob mindestens zwei Argumente übergeben wurden
    if (argc < 3) {
        printf("Please provide arguments.\n");
        return 1;
    }

    // Erhalte den Pfad zur URL-Datei
    const char *homeDir = getenv("HOME");
    if (!homeDir) {
        fprintf(stderr, "Error getting HOME environment variable\n");
        return 1;
    }

    char urlFilePath[FILENAME_MAX_LENGTH];
    snprintf(urlFilePath, FILENAME_MAX_LENGTH, "%s/.url/url.txt", homeDir);

    // Laden der URL-Datei
    FILE *urlFile = fopen(urlFilePath, "r");
    if (!urlFile) {
        perror("Error opening URL file");
        return 1;
    }

    char url[URL_MAX_LENGTH];
    char packageName[FILENAME_MAX_LENGTH];
    strcpy(packageName, argv[2]); // Paketname aus dem zweiten Argument kopieren

    // Schleife zum Durchlaufen jeder URL und Überprüfen des Paketstatus
    while (fgets(url, URL_MAX_LENGTH, urlFile)) {
        // Entferne newline-Zeichen am Ende der URL
        url[strcspn(url, "\n")] = 0;

        char filename[FILENAME_MAX_LENGTH];
        sprintf(filename, "%s.deb", packageName);

        // Konstruiere die vollständige URL des Pakets
        char fullUrl[URL_MAX_LENGTH];
        snprintf(fullUrl, URL_MAX_LENGTH, "%s/pkg/%s", url, packageName);

        printf("Checking %s for package: %s\n", url, packageName);

        // Überprüfen der Argumente und Durchführung entsprechender Aktionen
        if (strcmp(argv[1], "-i") == 0 || strcmp(argv[1], "-u") == 0 || strcmp(argv[1], "-d") == 0) {
            // Versuche das Paket herunterzuladen
            if (downloadFile(fullUrl, filename)) {
                printf("%s.deb found under %s\n", packageName, url);
                return 0;
            }
        } else if (strcmp(argv[1], "-si") == 0 || strcmp(argv[1], "-su") == 0 || strcmp(argv[1], "-sd") == 0) {
            // Nicht implementiert: Suchen nach alten oder neuen Versionen des Pakets
            printf("Searching for %s under %s\n", packageName, url);
            // Fügen Sie hier die Logik zum Suchen nach alten oder neuen Versionen hinzu
        } else {
            printf("Invalid argument provided.\n");
            return 1;
        }
    }

    printf("Package not found: %s\n", packageName);
    return 1;
}
