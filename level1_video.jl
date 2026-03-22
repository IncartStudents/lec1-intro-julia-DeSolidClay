# переписать ниже примеры из первого часа из видеолекции: 
# https://youtu.be/4igzy3bGVkQ
# по желанию можно поменять значения и попробовать другие функции
println("Hello")
a = 23
b = 1.425531
c = "Pom-pom"
typeof(a)
typeof(b)
typeof(c)
# арифметика
power = 10 ^ 2
mod = 101 % 2
print(mod)
# строки
s1 = "Bababa"
s2 = """Bla"Bla"Bla""" # можно вставить внутрь ковычки
println(s1, s2)

name = "Alex"
money = 100

println("If i was $name i would be nice")
println("I have $money bucks")

# конкатенация
string("Как же тут ", "много котов >:C")
string("Всего лишь ", 30, " котов")

s3 = "Как же тут "
s4 = "много котов XoX"
println(s3*s4)
println("$s3$s4")

# структуры данных
# 1) Словари (dictionary)
Phonebook = Dict("Jenny" => "867-3134", "Mark" => "123-1241") # создание словаря
Phonebook["Kramer"] = "123-5153" # добавление элемента
Phonebook["Kramer"] # достать значение по ключу
pop!(Phonebook, "Kramer") # удаление ключа

# 2) Кортежи их нельзя изменять! (Tuples)

animals = ("cats", "dogs", "crows") # индексирование с 1
animals[1]

# 3) Массив данных (array)
friends = [1.12342, "ted", "bob", "dude", 1, 5] 
friends[1]
push!(friends, "Grok") # добавить элемент
pop!(friends)       # удалить элемент
friends
nums2d = [[1, 2, 3], [4, 5, 6], [7, 8, 9]] # 2D Массив
nums3d = [[[1, 5, 3], [2, 3, 3], [3, 3, 3]], [[4, 3, 3], [5, 3, 3], [6, 3, 3]], [[7, 3, 3], [8, 3, 3], [9, 3, 8]]]

# циклы

for n in 1:10
    println(n)
end

for n = 1:10 # одно и то же
    println(n)
end 

for person in friends
    println("I like $person")
end

m, n = 5, 5
A = zeros(m, n)
for i in 1:m
    for j in 1:n
        A[i, j] = i + j
    end
end

B = zeros(m, n)
for i in 1:m, j in 1:n # вложженный цикл
    B[i, j] = i + j
end

C = [i + j for i in 1:m, j in 1:n] # По-джулиевски

# Условия
x = 5
y = 7
if x > y
    println("$x > $y")
elseif y > x
    println("$x < $y")
else
    println("$x = $y")
end

(x > y) ? println("$x > $y") : println("$x <= $y") # Аналог

(x < y) && println("всё верно") # Выполнение только при условии = True


# Функции
function sayhi(name, x)
    x = x^2
    println("Hi $name $x")
end
sayhi("Bob", 5)

sayhi3 = name -> println("Hi $name")

# Duck-typing - функция работает со всеми данными, если это имеет смысл
sayhi(2, 2)

# Мутирующие функции
v = [3, 4, 5]
sort(v) # v не изменится
sort!(v) # v изменится

# Транслирующие функции
A = [i + 3 * j for j in 0:2, i in 1:3]
function f(num)
    num = num^2
end
f(A) # функция применяется к матрице как к единому объекту
f.(A) # функция применяется к каждому элементу матрицы, транслирующая

# Пакеты
import Pkg

using Example
hello("me")

# Графика

using Plots
x = -3:0.1:3
# f(x) = x^2
# y = f.(x)
# gr()            # Plots.GRBackend()
# plot(x, y, label="line")
# scatter!(x, y, label="points")

# plotlyjs()
# plot(x, y, label="line")
# scatter!(x, y, label="points")

# globaltemperatures = [14.4, 14.5, 14.8, 15.2, 15.5, 15.8]
# numpirates = [45000, 200000, 15000, 5000, 400, 17]

# plot(numpirates, globaltemperatures, legend=false)
# scatter!(numpirates, globaltemperatures, legend=false)
# xflip!()
# xlabel!("Number of Pirates[Approximate]")
# ylabel!("Global Temperature (C)")
# title!("Influence of pirate population on gloabal warming")

# p1 = plot(x, x)
# p2 = plot(x, x.^2)
# p3 = plot(x, x.^3)
# p4 = plot(x, x.^4)
# plot(p1, p2, p3, p4, layout=(2, 2), legend=false)

# Multiple dispatch
# methods(+) Методы вызываемые "+"

# @which 3 + 3 Метод используемый в этой операции

# @which 3.0 + 3.0

# @which 3 + 3.0

# Создание нового метода для оператора "+"

import Base: +
+(x::String, y::String) = string(x, y)

println("hello " + "world!")
@which "hello " + "world!"

# Еще больше методов

foo(x, y) = println("duck-typed foo!")
foo(x::Int, y::Float64) = println("foo with int and float")
foo(x::Float64, y::Float64) = println("foo with two floats")
foo(x::Int, y::Int) = println("foo with two ints")

foo(1, 1)
foo(1.0, 1.0)
foo(1, 1.0)
foo(true, false)


# Линейная алгебра

A = rand(1:4, 3, 3) # случайные числа 1:4

B = A # Мы не сооздаем новую матрицу, а присваиваем B значение из той же памяти, что А
C = copy(A) # Тут мы создаем новую матрицу С
[B C]

A[1] = 17 # !!! Мы изменили A, B также изменилось
[B C]

x = ones(3)

b = A * x
Asym = A + A'
Apd = A'A # Умножение на транспонированную матрицу
A \ b     # решение уравнения Ax = b
Atall = A[:, 1:2]
display(Atall)
Atall \ b
A = randn(3, 3)
[A[:, 1] A[:, 1]] \ b

Ashort = A[1:2, :]
display(Ashort)
Ashort \ b[1:2]
