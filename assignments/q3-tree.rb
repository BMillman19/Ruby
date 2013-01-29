class Tree
  attr_accessor :children, :node_name

  def initialize(*params)
    first = params.pop
    second = params.pop

    if first.is_a? Hash
      @node_name = first.keys[0]
      @children = first[@node_name].map {|k,v| Tree.new({k => v})}
    else
      @node_name = first
      @children = second
    end

  end

  def visit_all(&block)
    visit &block
    children.each {|c| c.visit_all &block}
  end

  def visit(&block)
    block.call self
  end

  # will print out the node_name attribute for each member of the tree (DFS style)
  def print
    visit_all {|c| puts c.node_name}
  end

end