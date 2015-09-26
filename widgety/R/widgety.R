#' <Add Title>
#'
#' <Add Description>
#'
#' @import htmlwidgets
#'
#' @export
widgety <- function(message="Hello, world!",
                    radius=100,
                    circle_stroke="black",
                    circle_stroke_width=1,
                    circle_fill="steelblue",
                    family="Lato",
                    text_color="white",
                    width = NULL, height = NULL) {

  # forward options using x
  widget_options = list(
    message = message,
    radius = radius,
    circle_stroke = circle_stroke,
    circle_stroke_width = circle_stroke_width,
    circle_fill = circle_fill,
    family = family,
    text_color = text_color
  )

  # create widget
  htmlwidgets::createWidget(
    name = 'widgety',
    x = widget_options,
    width = width,
    height = height,
    package = 'widgety'
  )
}

#' Widget output function for use in Shiny
#'
#' @export
widgetyOutput <- function(outputId, width = '100%', height = '400px'){
  shinyWidgetOutput(outputId, 'widgety', width, height, package = 'widgety')
}

#' Widget render function for use in Shiny
#'
#' @export
renderWidgety <- function(expr, env = parent.frame(), quoted = FALSE) {
  if (!quoted) { expr <- substitute(expr) } # force quoted
  shinyRenderWidget(expr, widgetyOutput, env, quoted = TRUE)
}
