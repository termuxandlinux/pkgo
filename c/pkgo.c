#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

#define MAX_URL_LENGTH 200
#define MAX_PACKAGE_NAME_LENGTH 50

void downloadAndInstallPackage(const char *packageName) {
    char url[MAX_URL_LENGTH];
    char command[MAX_URL_LENGTH + 20];

    // Konstruiere die URL für das Paket
    snprintf(url, MAX_URL_LENGTH, "https://termux-pkg.netlify.app/%s/pkg/%s.deb", packageName, packageName);

    // Befehl zum Herunterladen des Pakets
    snprintf(command, sizeof(command), "wget %s -O %s.deb", url, packageName);

    // Paket herunterladen
    system(command);

    printf("Das neueste Paket wurde heruntergeladen: %s\n", packageName);

    // Befehl zum Installieren des Pakets
    snprintf(command, sizeof(command), "dpkg -i %s.deb", packageName);

    // Paket installieren
    system(command);

    // Heruntergeladene Datei entfernen
    snprintf(command, sizeof(command), "rm -f %s.deb", packageName);
    system(command);
}

int main(int argc, char *argv[]) {
    if (argc != 2) {
        printf("Bitte geben Sie den Paketnamen als Argument an.\n");
        return 1;
    }

    char *packageName = argv[1];
    downloadAndInstallPackage(packageName);

    return 0;
}
