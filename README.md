# Hello world

Créer un fichier `hello.c` :

```c
#include <stdio.h>

int main() {
    printf("Hello world!\n");
}
```

Sur windows, il faut installer un compilateur C (ex: [gcc](https://code.visualstudio.com/docs/cpp/config-mingw#_prerequisites)). Sur linux et mac, il est déjà installé.

Ouvrir un terminal dans le dossier du fichier :

```bash
$ gcc -o hello hello.c  # Compile le fichier
$ ./hello               # Exécute le fichier
Hello world!
```

# Variables

**Quand on déclare une variable sans l'initialiser, elle n'a pas de valeur par default, mais la valeur qui était à cet endroit dans la RAM.**

## Global

```c
// Hors d'une fonction, la variable est globale et accessible partout.
int i = 5;
```

## Const

```c
const int i = 5;  // non modifiable
```

## Static

Si utilisé pour une variable globale ou une fonction, elle sera accessible
uniquement dans le fichier courant.

```c
static int i = 5;
static void f() { }
```

Si utilisé dans une fonction, la variable ne sera pas supprimée à la fin
de la fonction. Elle sera donc initialisée une seule fois.

```c
void f() {
    static int i = 5;
    i++;
    printf("%i\n", i);
}

int main() {
    f();  // 6
    f();  // 7
}
```

## Pointer

Un pointeur est une variable qui contient une adresse mémoire.

<table>
    <tr>
        <th>Variable</th>
        <th>Adresse</th>
        <th>Valeur</th>
    </tr>
    <tr>
        <td>i</td>
        <td>71</td>
        <td>5</td>
    </tr>
    <tr>
        <td>p</td>
        <td>72</td>
        <td>71</td>
    </tr>
</table>

_`p` pointe vers `i`._

On peut utiliser `&` pour obtenir l'adresse d'une variable et `*` pour obtenir la valeur de la variable pointée.

```c
int i = 5;
int* p = &i;
printf("%p, %p, %i\n", &p, p, *p);  // 72, 71, 5
```

On peut utiliser `pointer->property` pour accéder à une propriété d'une structure pointée.

```c
struct Person {
    char* name;
    int age;
};

struct Person person = {"John", 42};
struct Person* p = &person;
printf("%s, %i\n", (*p).name, (*p).age);  // John, 42
printf("%s, %i\n", p->name, p->age);      // John, 42
```

## Array

**La taille d'un array doit être connue à la compilation, on ne peut pas utiliser une variable.**

_On peut cependant utiliser une valeur définie par `#define` (remplacé à la compilation) ou une allocation dynamique pour avoir une taille variable._

```c
int a1[5];              // Taille 5, non initialisé (valeurs aléatoires)
int a2[5] = {1, 2, 3};  // Taille 5, initialisé (1, 2, 3, 0, 0)
int a3[] = {1, 2, 3};   // Taille 3, initialisé (1, 2, 3)
int a4[5] = {0};        // Taille 5, initialisé (0, 0, 0, 0, 0)
for (int i = 0; i < 5; i++)
    a1[i] = 1;          // (1, 1, 1, 1, 1)
// int a7[array_size];  // Ne compile pas

printf("%i\n", a2[1])   // 2

// Taille d'un array :
// On divise la taille de l'array (en bytes) par la taille d'un élément (en bytes).
printf("%i\n", sizeof(a3) / sizeof(a3[0]));  // 3
```

### String

Un string est un array de `char` et se termine par un caractère nul (`\0`).

```c
char s[] = "Hello";  // {'H', 'e', 'l', 'l', 'o', '\0'}
char* s2 = "Hello";  // {'H', 'e', 'l', 'l', 'o', '\0'}
printf("%s, %s\n", s, s2);  // Hello, Hello

// Un array est un pointeur vers le premier élément, donc on peut faire :
printf("%s\n", s + 2);      // llo

// `strlen` renvoie l'index du caractère nul, plutôt que la taille de l'array.
len = strlen(s);
for (int i = 0; i < len; i++) {
    printf("%c", s[i]);  // Hello
}
```

`\n` est un caractère spécial (numéro 10 sur la table ASCII) qui représente un saut de ligne. On peut aussi utiliser `\12` (10 en octal) ou `\xA` (10 en hexadécimal).

Différence entre `char*` et `char[]` :

```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main(int argc, char **argv)
{
    // this is a pointer to a string literal, which is read-only
    char* readOnly = "hello";
    // this fails to compile
    // readOnly[1] = "i";

    // this assigns to the stack, which can be modified
    char stack[] = "hello";
    stack[1] = 'i';

    // this copies stack to the heap as a new variable
    int len = strlen(stack);
    char* heap = malloc((len + 1) * sizeof(char));
    strcpy(heap, stack);

    heap[1] = 'a';

    printf("%s\n",readOnly); // hello
    printf("%s\n",stack);    // hillo
    printf("%s\n",heap);     // hallo
    return 0;
}
```

## La relation entre array et pointer

Un array est en réalité un pointeur vers la première valeur de l'array.
On peut donc accéder aux valeurs d'un array en le déréférençant.

```c
int arr[5] = {1, 2, 3, 4, 5};
int* p = arr;
printf("%p == %p\n", arr, p);      // 70 == 70
printf("%p == %p\n", arr+1, p+1);  // 74 == 74
printf("%i == %i == %i == %i\n", arr[0], p[0], *arr, *p);          // 1 == 1 == 1 == 1
printf("%i == %i == %i == %i\n", arr[1], p[1], *(arr+1), *(p+1));  // 2 == 2 == 2 == 2
```

_Quand on additionne un pointeur avec un nombre, le pointeur est déplacé de `sizeof(type) * nombre`. Un int fait 4 bytes, donc `70+1*4 = 74`._

La différence est qu'on ne peut pas accéder à un élément en dehors de la taille de l'array, alors qu'on peut (on ne sait pas sur quelle variable on va tomber) avec un pointeur. Ex:

```c
int arr[5] = {1, 2, 3, 4, 5};
int* p = arr;
printf("%i\n", arr[14]);  // Error: index out of bounds
printf("%i\n", p[14]);    // Error: Segmentation fault
```

## Dynamic allocation

Il faut **toujours** libérer la mémoire allouée dynamiquement (memory leak).

### Memory allocation

```c
int* p = malloc(5 * sizeof(int));  // 5 * 4 = 20 bytes
if (!p) exit(1);  // Il n'y a plus de mémoire disponible, on quitte le programme
for (int i = 0; i < 5; i++)
    p[i] = i;
// p = {0, 1, 2, 3, 4}
```

### Memory reallocation

L'array peut être copié vers une nouvelle adresse (surtout si le nouvel array est plus grand que l'ancien), donc il faut mettre le pointeur à jour.

```c
p = realloc(p, 10 * sizeof(int));  // 10 * 4 = 40 bytes
if (!p) exit(1);  // Il n'y a plus de mémoire disponible, on quitte le programme
for (int i = 5; i < 10; i++)
    p[i] = i;
// p = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9}
```

### Memory deallocation

Il vaut mieux mettre le pointeur à NULL après l'avoir libéré, car il pointe toujours vers la meme adresse qui n'est plus allouée.

```c
free(p);
p = NULL;
```

# Types

## Integers

```c
char c;        // usually 1 byte
short s;       // usually 2 bytes
int i;         // usually 4 bytes
long l;        // usually 4 bytes
long long ll;  // usually 8 bytes
```

Ils peuvent être `signed` ou `unsigned` (2x plus grand, mais pas de négatifs) :

```c
signed int i = -5;
unsigned char c = 5;
```

On peut assigner un caractère :

```c
char c = 'A';  // 'A' sera remplacé par son code ASCII (65)
int i = 'B';   // 66

printf("%c, %i\n", c, c); // A, 65
printf("%c, %i\n", i, i); // B, 66
```

En fonction de la plateforme, les types entiers peuvent être de tailles différentes. On peut utiliser les types de taille fixe de `stdint.h`. Ca peut être utile si on cible un appareil avec une taille de mémoire limitée (ex: microcontrôleur).

```c
#include <stdint.h>

int8_t i = -5;   // 1 byte
uint64_t u = 5;  // 8 bytes
```

## Floating point

**Les nombres décimaux ne sont pas précis.** On peut comparer les décimaux à une notation scientifique. On a un nombre significatif et un exposant (ex: 5e42). La taille du nombre significatif est limitée, donc on perd de la précision sur les très grands nombres.

```c
float f = 5.5;         // 4 bytes
double d = 5.5;        // 8 bytes
long double ld = 5.5;  // 16 bytes
```

## Structure

```c
struct Person {
    char name[100];
    int age;
};

// Créer un alias, on peut maintenant utiliser `Animal` au lieu de `struct Animal`
typedef struct Animal Animal;
struct Animal {
    char name[100];
    int age;
};

// Autre syntaxe, on déclare la structure à la place de donner son nom :
// typedef struct Name Alias -> typedef struct { ... } Alias
typedef struct {
    char name[100];
    int age;
} Tree;

void edit_struct(Animal* animal) {
    strcpy(animal->name, "Cat");  // inclure <string.h>
    animal->age = 1;
    // or (*animal).age = 1;
}

void edit_name(char* name) {
    strcpy(name, "Lion");
}

void edit_age(int* age) {
    *age = 7;
}

int main() {
    struct Person person = {"John", 42};
    printf("%s, %i\n", person.name, person.age);  // John, 42
    Animal animal = {"Dog", 3};
    edit_struct(&animal);
    printf("%s, %i\n", animal.name, animal.age);  // Cat, 1
    edit_name(animal.name);
    edit_age(&animal.age);
    printf("%s, %i\n", animal.name, animal.age);  // Lion, 7
}
```

## Enum

```c
#include <stdio.h>

typedef enum Speed Speed;
enum Speed
{
    SLOW,    // 0
    NORMAL,  // 1
    FAST     // 2
};

typedef enum
{
    LOW = 25,
    MEDIUM = 50,
    HIGH = 75
} Volume;

int main()
{
    Speed speed = FAST;
    printf("%i\n", speed == FAST);      // 1 (true)
    printf("%i\n", speed);    // 2

    Volume volume = MEDIUM;
    printf("%i\n", volume == MEDIUM);   // 1 (true)
    printf("%i\n", volume);   // 50

    Volume volume2 = 51;
    printf("%i\n", volume2 == MEDIUM);  // 0 (false)
    printf("%i\n", volume2);  // 51
}
```

# Operators

## Arithmetic

```c
5 + 2;  // 7
5 - 2;  // 3
5 * 2;  // 10
5 / 2;  // 2
5 % 2;  // 1
```

## Assignment

```c
int i = 5;
i += 2;  // 7
i -= 2;  // 5
i *= 2;  // 10
i /= 2;  // 5
i %= 2;  // 1
```

## Increment and decrement

```c
int i = 5;
i++;  // 6
i--;  // 5

// Avec assignation (à éviter):
int j = i++;  // j = 5, i = 6
int k = ++i;  // k = 7, i = 7
```

## Comparison

```c
5 == 2;  // false
5 != 2;  // true
5 > 2;   // true
5 < 2;   // false
5 >= 2;  // true
5 <= 2;  // false
```

On peut utiliser `!`, `&&` et `||` pour faire des opérations booléennes.

```c
!true;                       // false
true && false;               // false
true || false;               // true
!((true && false) || true);  // false
```

## Bitwise

```c
9;       // 0000 1001
5;       // 0000 0101

9 & 5;   // 0000 0001 (AND)
9 | 5;   // 0000 1101 (OR)
9 ^ 5;   // 0000 1100 (XOR)
~9;      // 1111 0110 (NOT)
9 << 1;  // 0001 0010 (left shift)
9 >> 1;  // 0000 0100 (right shift)
```

# Loops

## For

```c
// for (init; cond; post)
for (int i = 0; i < 5; i++) {
    printf("%i\n", i);  // 0, 1, 2, 3, 4
}

for (int i = 0, j = 0; i < 5; i++, j += 2) {
    printf("%i, %i | ", i, j);  // 0, 0 | 1, 2 | 2, 4 | 3, 6 | 4, 8
}
```

## While

```c
int i = 0;
while (i < 5) {
    printf("%i\n", i);  // 0, 1, 2, 3, 4
    i++;
}
```

## Do while

La différence avec `while` est que le code est exécuté au moins une fois, même si la condition est fausse.

```c
int i = 0;
do {
    printf("%i\n", i);  // 0
    i++;
} while (i < 0);
```

## Break and continue

```c
for (int i = 0; i < 10; i++) {
    if (i == 2) {
        continue;  // Go to the next iteration
    }
    if (i == 4) {
        break;  // Exit the loop
    }
    printf("%i\n", i);  // 0, 1, 3
}
```

# Input

## scanf

Capture jusqu'au premier space/tab/newline, mais seul newline valide la saisie.

```c
int age;
scanf("%i", &age);                   // 42
printf("Hello %i, %i\n", age, age);  // Hello 42, 42

int a, b;
scanf("%i %i", &a, &b);    // 1 2
printf("%i, %i\n", a, b);  // 1, 2

char name[5];
// %4s pour laisser de la place pour le \0
scanf("%4s", name);          // Patrick
printf("Hello %s\n", name);  // Hello Patr
```

## fgets

Capture les caractères jusqu'au `\n` (inclus) ou jusqu'à la taille maximale (ici 5).

```c
char name[5];
fgets(name, 5, stdin);       // Patrick
printf("Hello %s\n", name);  // Hello Patr
```

## fflush

Les fonctions d'input laissent des caractères dans le buffer s'ils ne sont pas capturés (par exemple si l'input n'avait pas le bon type ou était trop long).

```c
char name[5];

// Sans fflush :
scanf("%4s", name);    // Patrick
scanf("%s", name);     // scanf lit "ick\n" dans le buffer
printf("%s\n", name);  // ick

// Avec fflush :
scanf("%4s", name);    // Patrick
fflush(stdin);
scanf("%s", name);     // 42
printf("%s\n", name);  // Hello 42
```

# Preprocessor

## Directives

Commence toujours par `#`. Le préprocesseur va remplacer le code avant la compilation, donc ca ne prend pas de place en mémoire.

```c
#include <stdio.h>
#define PI 3.14
```

## Conditions

````c
#if IS_DEBUG
    // Code
#elif IS_RELEASE
    // Code
#else
    // Code
#endif

#ifndef VIEWPORT_H
#define VIEWPORT_H
    // Code
#endif

## Constants

```c
printf("Erreur a la ligne %d du fichier %s\n", __LINE__, __FILE__);
printf("Ce fichier a ete compile le %s a %s\n", __DATE__, __TIME__);
````

## Macros

Elles sont copiées collées là où elles sont utilisées.

```c
#define MAX(a, b) ((a) > (b) ? (a) : (b))

...

MAX(5, 2)  // Pas de ;
```

# Files

## Open / Close

On ouvre un fichier avec `fopen` (qui le copie en mémoire) et on le ferme avec `fclose` (qui libère la mémoire). **Toujours fermer un fichier après l'avoir ouvert !**

```c
FILE *f = fopen("file.txt", "r");
if (!f) return 1;
fclose(f);
```

### Path

- relative: `"file.txt"`
- absolute (Windows): `"C:\\Users\\user\\file.txt"`
- absolute (Linux): `"/home/user/file.txt"`

### Open modes

<table>
    <tr>
        <th>Mode</th>
        <th>Signification</th>
        <th>Crée le fichier</th>
        <th>Supprime le contenu</th>
    </tr>
    <tr>
        <td><code>r</code></td>
        <td>read</td>
        <td>❌</td>
        <td>❌</td>
    </tr>
    <tr>
        <td><code>r+</code></td>
        <td>read and write</td>
        <td>❌</td>
        <td>❌</td>
    </tr>
        <td><code>w</code></td>
        <td>write</td>
        <td>✔️</td>
        <td>✔️</td>
    </tr>
    <tr>
        <td><code>w+</code></td>
        <td>write and read</td>
        <td>✔️</td>
        <td>✔️</td>
    </tr>
    <tr>
        <td><code>a</code></td>
        <td>append</td>
        <td>✔️</td>
        <td>❌</td>
    </tr>
    <tr>
        <td><code>a+</code></td>
        <td>append and read</td>
        <td>✔️</td>
        <td>❌</td>
    </tr>
</table>

## Write

```c
fputc('H', f);
fputs("ello world!\n", f);
fprintf(f, "%i %i %i", 1, 2, 3);
```

Le fichier contient maintenant `Hello world!\n1 2 3`

## Read

```c
rewind(f);                         // Remet le curseur au début
char c = fgetc(f);                 // c = 'H'
char str[100];
fgets(str, 100, f);                // str = "ello world!\n"
int a, b, c;
fscanf(f, "%i %i %i", &a, &b, &c); // a = 1, b = 2, c = 3
```

## Cursor

Les fonctions de lecture et écriture déplacent un curseur virtuel à chaque fois qu'elles sont appelées. On peut aussi le déplacer manuellement avec `fseek` et `rewind`.

```c
rewind(f);              // curseur au début
fseek(f, 0, SEEK_SET);  // curseur au début
fseek(f, 0, SEEK_END);  // curseur à la fin
fseek(f, 2, SEEK_CUR);  // curseur 2 caractères plus loin que la position actuelle
```

**Toujours utiliser les constantes `SEEK_SET` (0), `SEEK_CUR` (1) et `SEEK_END` (2) pour le 3ème paramètre.**

## Rename / remove

```c
rename("file.txt", "new_file.txt");
remove("new_file.txt");
```

---

TODO revoir la suite

---

# argc and argv

`argc` est le nombre d'arguments passés au programme, et `argv` est un array de strings contenant les arguments.

```c
#include <stdio.h>

int main(int argc, char** argv) {
    printf("argc: %i\n", argc);
    for (int i = 0; i < argc; i++) {
        printf("argv[%i]: %s\n", i, argv[i]);
    }
}
```

```bash
$ ./a.out hello world
argc: 3
argv[0]: ./a.out
argv[1]: hello
argv[2]: world

$ ./a.out "hello world"
argc: 2
argv[0]: ./a.out
argv[1]: hello world
```

# Outils

## Make

Make est un outil permettant de condenser des commandes dans un fichier `Makefile`.

```makefile
# Variables
CC=gcc

# Quand on tape `make` dans le terminal, la commande `all` est exécutée, elle dépends de `main`, donc `main` est exécutée avant.
all: main

main: main.c
	$(CC) -o main *.c

debug: main.c
    $(CC) -g -o main *.c
```

```bash
$ make
gcc -o main *.c
```

## gdb

GDB est un débogueur pour C et C++. Il permet de mettre des points d'arrêt, de voir les variables, la stack, etc.

```bash
$ gcc -g -o main main.c
$ gdb main
(gdb) break main        # Met un point d'arrêt à la fonction main
(gdb) break 5           # Met un point d'arrêt à la ligne 5
(gdb) watch global_var  # ?
(gdb) run               # Start le programme
(gdb) step              # Step into a function call
(gdb) next              # Step over a function call
(gdb)                   # Nothing: Repeat last command
(gdb) print global_var  # Print the value of a variable
(gdb) continue          # Continue until the next breakpoint
(gdb) quit              # Quit
```

# Environment variables

Ce sont des variables globales qui sont utilisées par le système d'exploitation et les programmes. `PATH` est une variable d'environnement qui contient les chemins vers les exécutables, qui sont donc accessibles depuis n'importe où.

```bash
# Print all environment variables
$ set  # Windows (cmd)
$ env  # Linux

# Print a specific environment variable
$ echo %PATH%  # Windows (cmd)
$ echo $PATH   # Linux
```

```c
char *username = getenv("USERNAME");
printf("USERNAME: %s\n", username);
```

On peut créer des variables d'environnement juste pour cette exécution du programme (et les programmes enfants)

```bash
$ MY_VAR=hello ./main
```

```c
setenv("MY_VAR", "hello", 1);
```

Ou pour la session du terminal.

```bash
$ export MY_VAR=hello
$ ./main
```
