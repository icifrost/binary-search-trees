class Node
  include Comparable

  attr_accessor :data, :left, :right

  def initialize(data)
    @data = data
    @left = nil
    @right = nil
  end

  def <=>(other)
    data <=> other.data
  end
end

class Tree
  attr_reader :root

  def initialize(array)
    @root = build_tree(array)
  end

  def build_tree(array)
    sorted_array = array.uniq.sort
    build_tree_helper(sorted_array, 0, sorted_array.length - 1)
  end

  def build_tree_helper(array, start_index, end_index)
    return nil if start_index > end_index

    mid_index = (start_index + end_index) / 2
    node = Node.new(array[mid_index])

    node.left = build_tree_helper(array, start_index, mid_index - 1)
    node.right = build_tree_helper(array, mid_index + 1, end_index)

    node
  end

  def insert(value)
    @root = insert_node(@root, value)
  end

  def insert_node(node, value)
    return Node.new(value) if node.nil?

    if value < node.data
      node.left = insert_node(node.left, value)
    elsif value > node.data
      node.right = insert_node(node.right, value)
    end

    node
  end

  def delete(value)
    @root = delete_node(@root, value)
  end

  def delete_node(node, value)
    return node if node.nil?

    if value < node.data
      node.left = delete_node(node.left, value)
    elsif value > node.data
      node.right = delete_node(node.right, value)
    else
      if node.left.nil?
        return node.right
      elsif node.right.nil?
        return node.left
      end

      min_right_subtree = find_min(node.right)
      node.data = min_right_subtree.data
      node.right = delete_node(node.right, min_right_subtree.data)
    end

    node
  end

  def find(value)
    find_node(@root, value)
  end

  def find_node(node, value)
    return nil if node.nil?

    if value == node.data
      node
    elsif value < node.data
      find_node(node.left, value)
    else
      find_node(node.right, value)
    end
  end

  def level_order(&block)
    return level_order_iterative(&block) unless block_given?

    queue = [@root]
    result = []

    until queue.empty?
      node = queue.shift
      block.call(node)
      result << node.data

      queue << node.left unless node.left.nil?
      queue << node.right unless node.right.nil?
    end

    result
  end

  def level_order_iterative
    result = []
    return result unless block_given?

    queue = [@root]

    until queue.empty?
      node = queue.shift
      yield node

      queue << node.left unless node.left.nil?
      queue << node.right unless node.right.nil?
    end
  end

def inorder(&block)
    return inorder_recursive(@root, &block) if block_given?

    result = []
    stack = []
    current = @root

    while !current.nil? || !stack.empty?
      while !current.nil?
        stack << current
        current = current.left
      end

      current = stack.pop
      result << current.data

      current = current.right
    end

    result
  end

   def preorder(&block)
    return preorder_recursive(@root, &block) if block_given?

    result = []
    stack = [@root]

    until stack.empty?
      current = stack.pop
      result << current.data

      stack << current.right unless current.right.nil?
      stack << current.left unless current.left.nil?
    end

    result
  end


  def postorder(&block)
    return postorder_recursive(@root, &block) if block_given?

    result = []

    postorder_recursive(@root) do |node|
      result << node.data
    end

    result
  end

  def height(node = @root)
    return -1 if node.nil?

    left_height = height(node.left)
    right_height = height(node.right)

    1 + [left_height, right_height].max
  end

  def depth(node)
    return -1 if node.nil?

    1 + depth(node.parent)
  end

  def balanced?
    balanced_recursive?(@root)
  end

  def rebalance
    values = inorder
    @root = build_tree(values)
  end

  def balanced_recursive?(node)
    return true if node.nil?

    left_height = height(node.left)
    right_height = height(node.right)

    return false if (left_height - right_height).abs > 1

    balanced_recursive?(node.left) && balanced_recursive?(node.right)
  end

  private

  def inorder_recursive(node, &block)
    return [] if node.nil?

    result = []
    result += inorder_recursive(node.left, &block)
    block.call(node)
    result << node.data
    result += inorder_recursive(node.right, &block)

    result
  end

  def preorder_recursive(node, &block)
    return [] if node.nil?

    result = []
    block.call(node)
    result << node.data
    result += preorder_recursive(node.left, &block)
    result += preorder_recursive(node.right, &block)

    result
  end

  def postorder_recursive(node, &block)
    return [] if node.nil?

    result = []
    result += postorder_recursive(node.left, &block)
    result += postorder_recursive(node.right, &block)
    block.call(node)
    result << node.data

    result
  end

  def find_min(node)
    current = node
    current = current.left until current.left.nil?
    current
  end
end

# Driver Script

# Step 1: Create a binary search tree from an array of random numbers
array = Array.new(15) { rand(1..100) }
tree = Tree.new(array)

# Step 2: Confirm that the tree is balanced
puts "Is the tree balanced? #{tree.balanced?}"

# Step 3: Print out all elements in level, pre, post, and in order
puts "Level order traversal: #{tree.level_order}"
puts "Preorder traversal: #{tree.preorder}"
puts "Postorder traversal: #{tree.postorder}"
puts "Inorder traversal: #{tree.inorder}"

# Step 4: Unbalance the tree by adding several numbers > 100
tree.insert(105)
tree.insert(110)
tree.insert(115)

# Step 5: Confirm that the tree is unbalanced
puts "Is the tree balanced after unbalancing? #{tree.balanced?}"

# Step 6: Balance the tree
tree.rebalance

# Step 7: Confirm that the tree is balanced after rebalancing
puts "Is the tree balanced after rebalancing? #{tree.balanced?}"

# Step 8: Print out all elements in level, pre, post, and in order
puts "Level order traversal: #{tree.level_order}"
puts "Preorder traversal: #{tree.preorder}"
puts "Postorder traversal: #{tree.postorder}"
puts "Inorder traversal: #{tree.inorder}"