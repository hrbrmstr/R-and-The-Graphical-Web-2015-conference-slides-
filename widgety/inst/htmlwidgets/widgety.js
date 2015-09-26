HTMLWidgets.widget({

  name: 'widgety',

  type: 'output',

  initialize: function(el, width, height) {

    return {
      w:width,
      h:height
    };

  },

  renderValue: function(el, x, instance) {

    var visDiv = d3.select(el);

    var svg = visDiv.append("svg")
          .attr("width", instance.w)
          .attr("height", instance.h);

    var circle = svg.append("circle")
          .attr("cx", instance.w/2)
          .attr("cy", instance.h/2)
          .attr("r", x.radius)
          .attr("stroke-width", x.circle_stroke_width)
          .attr("stroke", x.circle_stroke)
          .attr("fill", x.circle_fill);

    var label = svg.append("text")
         .attr("x", instance.w/2)
         .attr("y", instance.h/2)
         .attr("text-anchor", "middle")
         .attr("font-family", x.family)
         .attr("fill", x.text_color)
         .text(x.message);

  },

  resize: function(el, width, height, instance) {

  }

});
