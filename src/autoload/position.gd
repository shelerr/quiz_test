extends Node

"""
I have a lot of the containers in here, and most of them place children
according to very simple rules.
This class aims to provide very simple way to do that

It has 3 modes: simple, complex, fill
See correspronding functions for more details
"""

var tracked_nodes: Dictionary = {} # grouped by owner's id
# for simple and complex modes owner is parent container,
# for fill mode owner is viewport

enum PositionType{
    Simple, Complex, FillViewport
}

func set_simple(
        node: Control, point1_x, point1_y, point2_x, point2_y
):
    # This is a very simple (pun, perhaps, intended) mode:
    # we receive two points normilized drom 0 to 1 on both coordinates
    # (0, 0) being upper left, and (1, 1) - lower right
    # Then we multiply each point by parent's size (which supposed to be a container)
    # and we get upper left and lower right of given node rect
    # Of course this updates on every resort of children
#    var node_data := {
#        "node": node, "type": PositionType.Simple,
#        "point1_x": point1_x, "point1_y": point1_y,
#        "point2_x": point2_x, "point2_y": point2_y,
#    }
#    _add_node_generic(node, node_data)
    node.anchor_left   = point1_x
    node.anchor_right  = point2_x
    node.anchor_top    = point1_y
    node.anchor_bottom = point2_y
    node.margin_left   = 0.0
    node.margin_right  = 0.0
    node.margin_top    = 0.0
    node.margin_bottom = 0.0


func set_simple_funcref(
        node: Control, point1_x, point1_y, point2_x, point2_y
):
    var node_data := {
        "node": node, "type": PositionType.Simple,
        "point1_x": point1_x, "point1_y": point1_y,
        "point2_x": point2_x, "point2_y": point2_y,
    }
    _add_node_generic(node, node_data)

func set_complex(node: Control, row_1, row_2, row_3, row_4):
    # Mostly similar to simple, but has more parameters
    # We take 3x4 matrix, and multiply it by [x, y, 1], where x and y
    # are width and height of the parent container
    # Result of that multiplication is [x1, y1, x2, y2].
    # We use x1, y1 as first point, and x2, y2, as second
    # (they define upper-left and lower-right corner, respectively)

    var transform_matrix := [row_1, row_2, row_3, row_4]
    var transform := _canonicilize_matrix(transform_matrix)
    var node_data := {
        "node": node,
        "type": PositionType.Complex,
        "transform_matrix": transform,
    }
    _add_node_generic(node, node_data)
    
func set_complex_manual(node: Control, row_1, row_2, row_3, row_4):
    var transform_matrix := [row_1, row_2, row_3, row_4]
    var transform := _canonicilize_matrix(transform_matrix)
    var node_data := {
        "node": node,
        "type": PositionType.Complex,
        "transform_matrix": transform,
    }
    _reposition_node(node_data)
    
func _canonicilize_matrix(matrix: Array) -> Matrix:
    for i in range(4):
        if _is_numeric(matrix[i]):
            var temp: float = matrix[i]
            matrix[i] = [0, 0, 0]
            matrix[i][i%2] = temp
        elif len(matrix[i]) == 2:
            matrix[i].append(0)
        elif len(matrix[i]) != 3:
            assert(1 == 0, "Expected each row must have size 2 or 3 or be float") 
    return Matrix.new(matrix)

func set_fill(node: Control):
    # sets any node size, to size of it's viewport (i.e it fills viewport)
    # it's not necessarily true, because it doesn't affect position
    # of targeted node, but for current use, it should be fine
    var node_viewport:  = node.get_viewport()
    var viewport_id := node_viewport.get_instance_id()
    if not tracked_nodes.has(viewport_id):
        tracked_nodes[viewport_id] = []
    if not node_viewport.is_connected("size_changed", self, "_reposition_viewport_subscribers"):
        node_viewport.connect("size_changed", self, "_reposition_viewport_subscribers", [viewport_id])
        node_viewport.connect("tree_exited", self, "_remove_container", [viewport_id])

    tracked_nodes[viewport_id].append({"node": node})
    
    _reposition_viewport_subscribers(viewport_id) # REFACTOR this is O(n^2)...
    # Here we need it, since we aren't dealing with containers
    # and therefore we do not get signal in the beginning


func _reposition_container_children(container_id: int):
    for data in tracked_nodes[container_id]:
        if not is_instance_valid(data["node"]):
            tracked_nodes[container_id].erase(data)
            continue
        _reposition_node(data)


func _reposition_viewport_subscribers(viewport_id: int):
    for data in tracked_nodes[viewport_id].duplicate():
        # we have only fill mode for now
        if not is_instance_valid(data["node"]):
            tracked_nodes[viewport_id].erase(data)
            continue
        if data["node"].get_viewport() != null:
            var node_viewport = data["node"].get_viewport()
            data["node"].rect_size =  node_viewport.size

# code for simple and complex is very similar, so this is unified version
func _add_node_generic(node: Node, node_data: Dictionary):
    assert(node.get_parent() is Container, "Parent of connected node must be a container")
    var parent_container: Container = node.get_parent()
    var container_id := parent_container.get_instance_id()
    if not tracked_nodes.has(container_id):
        tracked_nodes[container_id] = []
    if not parent_container.is_connected("sort_children", self, "_reposition_container_children"):
        parent_container.connect("sort_children", self, "_reposition_container_children", [container_id])
        parent_container.connect("tree_exited", self, "_remove_container", [container_id])

    tracked_nodes[container_id].append(node_data)
    
    _reposition_node(node_data)


# Should only be called by connected signals, and from add_node
func _reposition_node(node_data: Dictionary):
    var node: Control = node_data["node"]
    var type: int = node_data["type"]

    var parent_container := node.get_parent() as Container
    var result_rect: Rect2
    if type == PositionType.Simple:
        result_rect = _get_result_rect_simple(node_data, parent_container.rect_size)
    if type == PositionType.Complex:
        result_rect = _get_result_rect_complex(node_data, parent_container.rect_size)
    parent_container.fit_child_in_rect(node, result_rect)


func _get_result_rect_simple(node_data: Dictionary, container_size: Vector2):
    # see set_simple
    var point1_x: float = _retrieve_data(node_data["point1_x"])
    var point1_y: float = _retrieve_data(node_data["point1_y"])
    var point2_x: float = _retrieve_data(node_data["point2_x"])
    var point2_y: float = _retrieve_data(node_data["point2_y"])
    return Rect2(
        Vector2(
            point1_x * container_size.x, 
            point1_y * container_size.y
        ),
        # Rect2 expects point and size, not 2 points
        Vector2(
            (point2_x - point1_x) * container_size.x,  
            (point2_y - point1_y) * container_size.y
        )    
    )


func _get_result_rect_complex(node_data: Dictionary, container_size: Vector2):
    # see set_complex
    var result_matrix: Matrix = node_data["transform_matrix"].mul(
            Matrix.new([[container_size.x], [container_size.y], [1]]))
    
    var result_array: Array = result_matrix.matrix
    
    return Rect2(
        Vector2(
            result_array[0][0], 
            result_array[1][0]
        ),
        # Rect2 expects point and size, not 2 points
        Vector2(
            result_array[2][0] - result_array[0][0], 
            result_array[3][0] - result_array[1][0]
        )    
    )


# Should only be called by connected signals
func _remove_container(node_id: int):
    tracked_nodes.erase(node_id)

func _retrieve_data(val):
    if val is FuncRef:
        return val.call_func()
    else:
        return val

func _is_numeric(val) -> bool:
    return (val is float) or (val is int)
