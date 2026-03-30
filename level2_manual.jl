# Выболнить большую часть заданий ниже - привести примеры кода под каждым комментарием


#===========================================================================================
1. Переменные и константы, области видимости, cистема типов:
приведение к типам,
конкретные и абстрактные типы,
множественная диспетчеризация,
=#

# Что происходит с глобальной константой PI, о чем предупреждает интерпретатор?
##
const PI = 3.14159 # Ключевое слово const определяет переменную как неизменяемую
# PI = 3.14 

##
# Что происходит с типами глобальных переменных ниже, какого типа `c` и почему?
a = 1
b = 2.0
c = a + b # По правилу Promotion Int64 обобщается до Float64, глобальные переменные имеют нестабильные типы
# c - Float64
##
# Что теперь произошло с переменной а? Как происходит биндинг имен в Julia?
a = "foo" # Переменная была перепривязана к "foo" типа String
# Значение 1 осталось в памяти без привязки

##
# Что происходит с глобальной переменной g и почему? Чем ограничен биндинг имен в Julia?
g::Int = 1 # Переменная g фиксированного типа Int, биндинг ограничен типовыми переменными
# g = "hi" Выдает ошибку из-за попытки поменять тип

function greet() # Биндинг ограничен областью применения
    g = "hello" # Локальная переменная не влияет на глобальную
    println(g)
end
greet()
# Биндинг ограничен константами const
## 
# Чем отличаются присвоение значений новому имени - и мутация значений?
v = [1,2,3]
z = v # z отсылается на ту же область памяти что и v, лишняя память не затрачена
v[1] = 3 # мутация - изменение объекта, к которому привязано имя v. 
v = "hello"
z       # z привязана к тому же объекту, что и v. также изменяется

## 
# Написать тип, параметризованный другим типом
struct coords{T}
    x::T
    Y::T
end
p1 = coords(1.0, 30.5)
p1
##
# Написать функцию для двух аругментов, не указывая их тип:
function F(x, y)
    println(x, y)
    
end
# и вторую функцию от двух аргментов с конкретными типами
function H(x::Int, y::Float64)
    println(x, y)
    
end
#дать пример запуска
F("1", 2)
H(4, 5.6) # Выдает ошибку при несоответствии типов аргументов
##

# Абстрактный тип - ключевое слово 
# На основе абстраткного типа не могут быть создраны объекты
# Не могут быть объявлены дочерними
# Для группировки конкретных типов
# Для задания интерфейса функции
# Для управления областью создания классов
abstract type Pet end
struct Dog <: Pet; name::String end
struct Cat <: Pet; name::String end

function encounter(a::Pet, b::Pet)
    verb = meets(a, b)
    println("$(a.name) встречает $(b.name) и $verb.")
end


meets(a::Dog, b::Dog) = "нюхает"
meets(a::Dog, b::Cat) = "гонится"
meets(a::Cat, b::Dog) = "шипит"
meets(a::Cat, b::Cat) = "мурлычит"

fido = Dog("Рекс")
rex = Dog("Мухтар")
whiskers = Cat("Матроскин")
spots = Cat("Бегемот")

encounter(fido, rex)       
encounter(fido, whiskers)  
encounter(whiskers, rex)   
encounter(whiskers, spots) 



# Примитивный тип - ключевое слово 
# Не рекомендуется Использовать
# Объекты примитивного типа имеют заданный фиксированный размер памяти
primitive type Float16 <: AbstractFloat 16 end
primitive type Float32 <: AbstractFloat 32 end
primitive type Float64 <: AbstractFloat 64 end


# Композитный тип - ключевое слово struct
# Состоит из нескольких типов
# Неизменяемый композитный тип: после создания нельзя поменять поля
struct Mountain
    first_ascent_year::Int16
    height::UInt16
end

Everest = Mountain(1953,8848)
Int(Everest.height)

# Изменяемый - поля можно менять
mutable struct MutableStudent
    const name::String
    grade::UInt8        # класс
    grades::Vector{Int} # оценки
end
Peter = MutableStudent("Peter", 1, [5,5,5])
Peter.grade = 2
##
#=
Написать один абстрактный тип и два его подтипа (1 и 2)
Написать функцию над абстрактным типом, и функцию над её подтипом-1
Выполнить функции над объектами подтипов 1 и 2 и объяснить результат
(функция выводит произвольный текст в консоль)
=#
#Создание типов
abstract type Army end
struct Archers <: Army
    num::Int16
    weapon::String
end
struct Warriors <: Army 
    num::Int16
    weapon::String
end

# Создание функций
function ArmyStructure(::Army)
    println("Армия состоит из лучников и воинов")
end

function ArchrNum(archr::Archers)
    num = archr.num
    println("Количество лучников - $num")
end
# Создание объектов
archr1 = Archers(100, "Длинный лук")
warr1 = Warriors(200, "Полуторный меч")

# Проверка
ArmyStructure(archr1) # Аргумент функции должен принадлежать типу Army
ArmyStructure(warr1)
ArchrNum(archr1)
ArchrNum(warr1) # аргумент функции должен принадлежать типу Archers 
##
#===========================================================================================
2. Функции:
лямбды и обычные функции,
переменное количество аргументов,
именованные аргументы со значениями по умолчанию,
кортежи
=#

## Пример обычной функции
function(x, y)
    x + y
end
##
# Пример лямбда-функции (аннонимной функции)
y = (x -> x^2 + 2x - 1) # так
y(1)

function (x)            # либо так
    x^2 + 2x - 1
end
##
# Пример функции с переменным количеством аргументов
people = []
function PeopleCount(city, names...)
    counter = 0
    for name in names
        push!(people, name)
        counter += 1
    end
    println("Жители города $city:")
    println(people)
    println(counter)
end
PeopleCount("Майами", "Man1", "Man2", "Man3")
##
# Пример функции с именованными аргументами
function PersonInfo(name; age="Нет данных", city="Нет данных")
    println("Имя: $name, Возраст: $age, Город: $city")
end

PersonInfo("Ваня")
PersonInfo("Федя", age=25)
PersonInfo("Саша", city="Москва")
PersonInfo("Гоша", age=30, city="Владивосток")
##
# Функции с переменным кол-вом именованных аргументов
function PersonInfo(name; age="Нет данных", city="Нет данных", hobbies...)
    println("Имя: $name, Возраст: $age, Город: $city")
    println("Увлечения:")
    for hobby in hobbies
        println(hobby)
    end
end
PersonInfo("Гоша", age=30, city="Владивосток", sport="Футбол", fun="Тусовки", school="Рисование")
##
##
#=
Передать кортеж в функцию, которая принимает на вход несколько аргументов.
Присвоить кортеж результату функции, которая возвращает несколько аргументов.
Использовать splatting - деструктуризацию кортежа в набор аргументов.
=#
# "..." - деструктуризация
data = (512, 123, 534, 233, 531, 976, 123, 634, 124, 745)
function stats(data...)
    n = length(data)
    if n == 0
        println("Нет данных")
    elseif n == 1
        return data[1]
    else
        return sum(data), minimum(data), maximum(data)
    end
end
data1 = stats(data...)
println(data1)


##
#===========================================================================================
3. loop fusion, broadcast, filter, map, reduce, list comprehension
=#

#=
Перемножить все элементы массива
=#
## - через loop fusion и
nums = [1, 2, 3, 4, 5]
@time nums .* nums
## - с помощью reduce
nums = [1, 2, 3, 4, 5]
@time reduce(*, nums)
##
#=
Написать функцию от одного аргумента и запустить ее по всем элементам массива
=#
nums = [1, 2, 3, 4, 5]
function sqr(nums)
    return nums^2
end

# с помощью точки (broadcast)
@time sqr.(nums) # 0.028790 seconds (76.53 k allocations: 3.866 MiB)


# c помощью map
@time map(sqr, nums) # 0.019184 seconds (42.22 k allocations: 2.038 MiB)


# c помощью list comprehension
@time [sqr(n) for n in nums] # 0.022971 seconds (41.57 k allocations: 2.005 MiB)

# указать, чем это лучше явного цикла?
# Такие функции намного компактнее, но при этом не теряют производительности
##
# Перемножить вектор-строку [1 2 3] на вектор-столбец [10,20,30] и объяснить результат
# Умножение матриц происходит в соответствии с правилами алгебры
A = [1 2 3] # 1 x 1
B = [10, 20, 30] # 3 x 3
C = A * B 
В = B * A 

# В одну строку выбрать из массива [1, -2, 2, 3, 4, -5, 0] только четные и положительные числа
m = [1, -2, 2, 3, 4, -5, 0]
l = length(m)
ans = [n for n in m if (n > 0) && (n % 2 == 0)]'
##
# Объяснить следующий код обработки массива names - что за number мы в итоге определили?
using Random
Random.seed!(123)
names = [rand('A':'Z') * '_' * rand('0':'9') * rand([".csv", ".bin"]) for _ in 1:100]
println(names)

# ---
#=
same_names = unique(map(y -> split(y, ".")[1], filter(x -> startswith(x, "A"), names)))

numbers = parse.(Int, map(x -> split(x, "_")[end], same_names))
numbers_sorted = sort(numbers)
number = findfirst(n -> !(n in numbers_sorted), 0:9)
## Выбираем уникальные названия файлов без расширения -> Выбираем номера из названий файлов -> Сортируем ->
## -> Находим индекс первой цифры из массива 0:9, которой нет в номерах файлов, т.е. индекс 2, цифра 1
=#
##
# Упростить этот код обработки:
using Random
Random.seed!(123)
names = [rand('A':'Z') * '_' * rand('0':'9') * rand([".csv", ".bin"]) for _ in 1:100]
#println(names)

same_names = [parse(Int, n[3]) for n in names if startswith(n, "A")]
numbers_sorted = [n for n in unique!(sort(same_names))]
missing_numbers = [n for n in 0:9 if ~(n in numbers_sorted)]


##
#===========================================================================================
4. Свой тип данных на общих интерфейсах
=#
##
#=
написать свой тип ленивого массива, каждый элемент которого
вычисляется при взятии индекса (getindex) по формуле (index - 1)^2
=#
struct LazyArray
    len::Integer
end
function getindex(len::Integer)
    A = LazyArray(len)
    return [(i - 1)^2 for i in 1:A.len ]
end
println(getindex(6))
##
#=
Написать два типа объектов команд, унаследованных от AbstractCommand,
которые применяются к массиву:
`SortCmd()` - сортирует исходный массив
`ChangeAtCmd(i, val)` - меняет элемент на позиции i на значение val
Каждая команда имеет конструктор и реализацию метода apply!
=#

abstract type AbstractCommand end
struct SortCmd <: AbstractCommand; target::Vector end
struct ChangeAtCmd <: AbstractCommand; target::Vector; i::Integer; val::Integer end
apply!(cmd::AbstractCommand, target::Vector) = error("Not implemented for type $(typeof(cmd))")

target = [5, 4, 3, 2, 1]
target2 = [5, 4, 3, 2, 1]

SortTarget = SortCmd(target2)
ChangeTarget = ChangeAtCmd(target, 1, 4)

apply!(SortTarget) = sort!(target2.SortTarget)
apply!(ChangeTarget) = replace!(target, target[ChangeTarget.i] => ChangeTarget.val)

# Аналогичные команды, но без наследования и в виде замыканий (лямбда-функций)
i = 1
val = 10
Chng = target -> replace!(target, target[i] => val)
Srt = target -> sort(target)
Chng(target)
##
#===========================================================================================
5. Тесты: как проверять функции?
=#

# Написать тест для функции
using Test
nums = [1, 2, 3, 4, 5]
function sqr(nums)
    return nums^2
end
@test sqr.(nums) == [1, 4, 9, 16, 25]
##
#===========================================================================================
6. Дебаг: как отладить функцию по шагам?
=#

#=
Отладить функцию по шагам с помощью макроса @enter и точек останова
=#
using Debugger

nums = [1, 2, 3, 4, 5]
function sqr(nums)
    return nums^2
end
Debugger.@enter sqr.(nums)

##
#===========================================================================================
7. Профилировщик: как оценить производительность функции?
=#

#=
Оценить производительность функции с помощью макроса @profview,
и добавить в этот репозиторий файл со скриншотом flamechart'а
=#
function generate_data(len)
    vec1 = Any[]
    for k = 1:len
        r = randn(1,1)
        append!(vec1, r)
    end
    vec2 = sort(vec1)
    vec3 = vec2 .^ 3 .- (sum(vec2) / len)
    return vec3
end
ProfileView.@profview generate_data(1_000_000)

##
# @time generate_data(1_000_000);
using ProfileView



# Переписать функцию выше так, чтобы она выполнялась быстрее:

function generate_data(len)
    vec1 = [rand(1:10) for i = 1:len]
    vec1 = sort!(vec1)
    vec1 = vec1 .^ 3 .- (sum(vec1) / len)
    return vec1
end
ProfileView.@profview generate_data(1_000_000)
##
#===========================================================================================
8. Отличия от матлаба: приращение массива и предварительная аллокация?
=#
##
#=
Написать функцию определения первой разности, которая принимает и возвращает массив
и для каждой точки входного (x) и выходного (y) выходного массива вычисляет:
y[i] = x[i] - x[i-1]
=#
X = [2*t for t = 1:100]
function df(X, Fd)
    Y = [X[i] - X[i-1] for i = 2:length(X)]
    Y = Y * Fd
    return Y
end
ProfileView.@profview df(X, 1)

##
#=
Аналогичная функция, которая отличается тем, что внутри себя не аллоцирует новый массив y,
а принимает его первым аргументом, сам массив аллоцируется до вызова функции
=#
X = [2*t for t = 1:100]
Y = zeros(length(X))
function df!(Y)
    for i = 2:length(Y)
        Y[i] = X[i] - X[i-1]
    end
end
ProfileView.@profview df!(Y)

##
#=
Написать код, который добавляет элементы в конец массива, в начало массива,
в середину массива
=#
X = [2*t for t = 1:100]
Y = [3, 2]
y = 505
#println(append!(X, Y))
#println(append!(Y, X))
function push_middle(X, y)
    l = length(X)
    if l % 2 == 0
        insert!(X, l/2 + 1, y)
    else
        insert!(X, convert(Int64, floor(l / 2)), y)
    end
end
push!(X, 101)
push_middle(X, y)
println(X[50])
##
#===========================================================================================
9. Модули и функции: как оборачивать функции внутрь модуля, как их экспортировать
и пользоваться вне модуля?
=#


#=
Написать модуль с двумя функциями,
экспортировать одну из них,
воспользоваться обеими функциями вне модуля
=#
module Foo
    #export ?
end
# using .Foo ?
# import .Foo ?


#===========================================================================================
10. Зависимости, окружение и пакеты
=#

# Что такое environment, как задать его, как его поменять во время работы?
#= 
Environment в Julia — это коллекция пакетов, настраивается с помощью Pkg
=#

# Что такое пакет (package), как добавить новый пакет?
#=
Пакет - это коллекция модулей, обычно с дополнительной документацией и тестами.
Пакеты добавляются через Pkg
=#

# Как начать разрабатывать чужой пакет?
#=
Разработать пакет можно с помощью Pkg, создав новую среду с базовой структурой пакета
=#

#=
Как создать свой пакет?
(необязательно, эксперименты с PkgTemplates проводим вне этого репозитория)
=#

##
#===========================================================================================
11. Сохранение переменных в файл и чтение из файла.
Подключить пакеты JLD2, CSV.
=#

# Сохранить и загрузить произвольные обхекты в JLD2, сравнить их
using JLD2
hello = "world"
# save_object("example.jld2", hello)
hi = load_object("example.jld2")

##
# Сохранить и загрузить табличные объекты (массивы) в CSV, сравнить их
using CSV, DataFrames

# write out a DataFrame to csv file
dframe = DataFrame(rand(10, 10), :auto)
CSV.write("data.csv", dframe)

##
#===========================================================================================
12. Аргументы запуска Julia
=#

#=
Как задать окружение при запуске?
Задать окружение можно с помощью аргументов окружения:
JULIA_NUM_THREADS - установка количества потоков
JULIA_PROJECT     - путь для окружения
JULIA_DEPOT_PATH  - путь для установленных пакетов
JULIA_LOAD_PATH   - путь откуда устанавливаются пакеты
JULIA_PKG_SERVER  - url сайта с пакетами
JULIA_EDITOR      - выбор редактора для отладки
и тд
=#

#=
Как задать скрипт, который будет выполняться при запуске:
а) из файла .jl
julia script.jl arg1 arg2 arg3
б) из текста команды? (см. флаг -e)
julia -e 'команда'
=#

#=
После выполнения задания Boids запустить julia из командной строки,
передав в виде аргумента имя gif-файла для сохранения анимации
=#
