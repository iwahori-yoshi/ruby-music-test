require 'rubyvis'

module Ongaku
  class Plotter
    def initialize(&converter)
      @converter = converter
    end

    def plot(data)
      if @converter
        data = data.map(&@converter)
      end

      w = 400
      h = 200
      x = pv.Scale.linear(0, data.length).range(0, w)
      y = pv.Scale.linear(data).range(0, h);
      
      vis = pv.Panel.new()
        .width(w)
        .height(h)
        .bottom(10)
        .left(30)
        .right(100)
        .top(10)
      
      # 横线
      vis.add(pv.Rule)
        .data(y.ticks())
        .bottom(y)
        .strokeStyle(->(d){d != 0 ? '#eee' : '#000'})
        .anchor('left').add(pv.Label)
          .text(y.tick_format)
      
      # 竖线
      vis.add(pv.Rule)
        .data(x.ticks())
        .left(x)
        .stroke_style{|d| d != 0 ? '#eee' : '#000'}
      .anchor("bottom")
      
      # 0 横线描黑
      vis.add(pv.Rule)
        .data([0])
        .bottom(y)
        .stroke_style{|d| d!=0 ? '#b0b0b0' : '#000'}
      
      vis.add(pv.Line)
        .data(data)
        .line_width(1.5)
        .left{x.scale(self.index)}
        .bottom{|v| y.scale(v)}

      vis.render
      IRuby.display(vis.to_svg, mime: 'image/svg+xml')
      return
    end
  end
end