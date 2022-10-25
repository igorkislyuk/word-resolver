# Программа для выбора слова 

# Команды работы программы

По умолчанию программа работает с словами из 5 букв. Возможно, стоит поправить и поддержать другое количество, но пока не до этого.

- `/start` - начало работы программы
- `/end` - конец работы программы
- `-` - указание символа для слова. Так обозначается символ отсутствия буквы
- `+` - указание символа для слова. Так обозначается символ присутствия буквы
- `*` - указание символа для слова. Так обозначается символ буквы на своем месте

Пример: при выводе программой слова `топор`, а при искомом `ропот`, маска должна составлять `+***+`

# Алгоритм работы программы


# Ресурсы программы 

1. В проекте есть файл со всеми русскими словами, взятый [отсюда](https://github.com/danakt/russian-words). Спасибо автору
2. В проекте есть файл с русскими словами, отфильтрованный по количеству букв (5) из файла выше `russian-5.txt`