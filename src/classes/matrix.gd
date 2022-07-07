class_name Matrix

var x: int = - 1 # size
var y: int = - 1

var matrix: Array

func _init(matrix_: Array):
    matrix = matrix_
    y = len(matrix_)
    assert(y > 0, "Matrix has to have at least one row")
    x = len(matrix_[0])
    for i in y:
        assert(len(matrix_[i]) == x, "Matrix row have to have same length")

func mul(other: Matrix) -> Matrix:
    var new_matrix: Array = []
    new_matrix.resize(y)
    assert (x == other.y, "The number of columns in the first matrix should be" + 
            "equal to the number of rows in the second")
    for i in range(y):
        new_matrix[i] = []
        new_matrix[i].resize(other.x)
        for j in range(other.x):
            new_matrix[i][j] = 0
            for k in range(x):
                new_matrix[i][j] += matrix[i][k] * other.matrix[k][j]
    return get_script().new(new_matrix)
