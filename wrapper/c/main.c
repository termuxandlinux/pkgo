#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

int main(int argc, char *argv[]) {
    // Überprüfen, ob Argumente vorhanden sind
    if (argc == 1) {
        printf("Please provide arguments.\n");
        return 1;
    }

    // Überprüfen, ob das erste Argument "-i" ist
    if (strcmp(argv[1], "-i") == 0) {
        // Überprüfen, ob genau zwei Argumente bereitgestellt wurden
        if (argc != 3) {
            printf("Usage: %s -i <package_name>\n", argv[0]);
            return 1;
        }

        // Paket installieren
        char *packageName = argv[2];
        char url[100];
        sprintf(url, "https://termux-pkg.netlify.app/%s/pkg/%s.deb", packageName, packageName);
        char cmd[100];
        sprintf(cmd, "wget %s", url);
        system(cmd);
        printf("The latest package has been downloaded: %s\n", packageName);
        sprintf(cmd, "dpkg -i %s.deb", packageName);
        system(cmd);
        sprintf(cmd, "rm -r -f %s.deb", packageName);
        system(cmd);
        return 0;
    }

    // Überprüfen, ob das erste Argument "install" oder "search" ist
    if (strcmp(argv[1], "install") == 0 || strcmp(argv[1], "search") == 0) {
        // Überprüfen, ob genau zwei Argumente bereitgestellt wurden
        if (argc != 3) {
            printf("Usage: %s [install|search] <package_name>\n", argv[0]);
            return 1;
        }

        // Argumente an "pkg" Befehl übergeben
        execvp("pkg", argv+1);
        printf("Failed to execute pkg command.\n");
        return 1;
    }

    printf("Invalid arguments provided.\n");
    return 1;
}
