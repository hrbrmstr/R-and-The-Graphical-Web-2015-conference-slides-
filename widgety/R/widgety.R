#' <Add Title>
#'
#' <Add Description>
#'
#' @import htmlwidgets
#'
#' @export
widgety <- function(message, width = NULL, height = NULL) {

  # forward options using x
  x = list(
    message = message
  )

  # create widget
  htmlwidgets::createWidget(
    name = 'widgety',
    x,
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
