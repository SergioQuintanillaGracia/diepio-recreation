extra_points = 20
extra_points_up = 10
iterations = 0
extra_points_list = []

print("Extra extra points each level will need: ")

for i in range(5):
    for j in range(8):
        print(extra_points, end = ", ")
        extra_points_list.append(extra_points)
        iterations += 1

        if iterations % 3 == 0:
            extra_points_up += 10

        extra_points += extra_points_up

    print("")



points = 0
index = 0

print("\n Points for each level: ")

for i in range(5):
    for i in range(8):
        points += extra_points_list[index]
        print(points, end = ", ")
        index += 1

    print("")