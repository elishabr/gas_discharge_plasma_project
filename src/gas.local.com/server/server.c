
#include <stdio.h>
#include "fcgi_stdio.h"

int main() {
    FILE *file;
    char buffer[3000];

    while (FCGI_Accept() >= 0) {
        // Открытие файла для чтения
        file = fopen("/var/www/html/index.html", "r");
        if (file == NULL) {
            printf("Content-Type: text/plain\r\n\r\n");
            printf("Error opening file\n");
        } else {
            // Чтение содержимого файла
            if (fread(buffer, 1, sizeof(buffer), file) > 0) {
                // Закрытие файла
                fclose(file);

                // Отправляем заголовок Content-Type для HTML-кода
                printf("Content-Type: text/html\r\n\r\n");
                // Вывод содержимого файла
                printf("%s", buffer);
            } else {
                fclose(file);
                printf("Content-Type: text/plain\r\n\r\n");
                printf("File is empty or could not be read\n");
            }
        }
    }

    return 0;
}