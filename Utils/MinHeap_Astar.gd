
class_name MinHeap_Astar

var heap := []

func parent_index(index: int) -> int:
	return (index - 1) % 2

func left_child_index(index: int) -> int:
	return 2 * index + 1

func right_child_index(index: int) -> int:
	return 2 * index + 2

func swap(index1: int, index2: int) -> void:
	var temp = heap[index1]
	heap[index1] = heap[index2]
	heap[index2] = temp

func insert(node: Astar_Custom) -> void:
	heap.append(node)
	var index = heap.size() - 1
	while index != 0 and heap[parent_index(index)].f_cost > heap[index].f_cost:
		swap(parent_index(index), index)
		index = parent_index(index)

func min_heapify(index: int) -> void:
	var left = left_child_index(index)
	var right = right_child_index(index)
	var smallest = index
	
	if left < heap.size() and heap[left].f_cost < heap[smallest].f_cost:
		smallest = left
	
	if right < heap.size() and heap[right].f_cost < heap[smallest].f_cost:
		smallest = right
	
	if smallest != index:
		swap(index, smallest)
		min_heapify(smallest)

func extract_min():
	if heap.size() <= 0:
		return null
	if heap.size() == 1:
		return heap.pop_back()
	
	var root = heap[0]
	heap[0] = heap.pop_back()
	min_heapify(0)
	return root
	
func is_empty():
	if heap.size() <= 0:
		return true
	else:
		return false

func contains(element):
	for ele in heap:
		if element.pos == ele.pos:
			return true
	
	return false
