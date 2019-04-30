#' American politics-inspired color palettes
#'
#' Use \code{\link{amerika_palette}} to produce desired color palette
#'
#' @export
amerika_palettes <- list(
  Republican = c("#8b0000", "#d30b0d", "#d27979"),
  Democrat = c("#013364", "#0033cc", "#428bca"),
  Dem_Ind_Rep3 = c("#013364", "#cbcaca", "#cc0000"),
  Dem_Ind_Rep5 = c("#013364", "#0033cc", "#cbcaca", "#d30b0d", "#8b0000"),
  Dem_Ind_Rep7 = c("#013364", "#0033cc", "#428bca", "#cbcaca", "#d27979", "#d30b0d", "#8b0000")
)

#' amerika color palette generator
#'
#' @usage amerika_palette("name", n, "type")
#' @param n Number of colors to select from the palette. If null, then all colors in the palette are selected
#' @param name Name of the specific palette in quotation marks. The options are: \code{Republican}, \code{Democrat}, \code{Dem_Ind_Rep3}, \code{Dem_Ind_Rep5}, \code{Dem_Ind_Rep7}
#' @param type Specify the type of color mapping, either "continuous" or "discrete" in quotation marks. Use "continuous" to include more colors than those in the palette. See \code{examples} below for more
#'   @importFrom graphics rgb rect par image text
#' @references Karthik Ram and Hadley Wickham. 2015. wesanderson: a Wes Anderson palette generator. R package version 0.3.
#' @return A vector of colors
#' @export
#' @examples
#' # Display each palette
#' amerika_palette("Republican")
#' amerika_palette("Democrat")
#' amerika_palette("Dem_Ind_Rep3")
#' amerika_palette("Dem_Ind_Rep5")
#' amerika_palette("Dem_Ind_Rep7")
#'
#' # Interpolating between existing colors based on the palettes using the "continuous" type
#' amerika_palette(50, name = "Republican", type = "continuous")
#' amerika_palette(50, name = "Democrat", type = "continuous")
#' amerika_palette(50, name = "Dem_Ind_Rep3", type = "continuous")
#' amerika_palette(50, name = "Dem_Ind_Rep5", type = "continuous")
#' amerika_palette(50, name = "Dem_Ind_Rep7", type = "continuous")

amerika_palette <- function(name, n, type = c("discrete", "continuous")) {
  type <- match.arg(type)

  pal <- amerika_palettes[[name]]
  if (is.null(pal))
    stop("You supplied the name of a palette not included in 'amerika'.")

  if (missing(n)) {
    n <- length(pal)
  }

  if (type == "discrete" && n > length(pal)) {
    stop("The number of requested colors is more than those offered by the palette.\n
         Consider changing the palette or the number of requested colors.")
  }

  out <- switch(type,
                continuous = grDevices::colorRampPalette(pal)(n),
                discrete = pal[1:n]
  )
  structure(out, class = "palette", name = name)
}

#' @export
#' @importFrom graphics rect par image text
#' @importFrom grDevices rgb
print.palette <- function(x, ...) {
  n <- length(x)
  old <- par(mar = c(0.5, 0.5, 0.5, 0.5))
  on.exit(par(old))

  image(1:n, 1, as.matrix(1:n), col = x,
        ylab = "", xaxt = "n", yaxt = "n", bty = "n")

  rect(0, 0.9, n + 1, 1.1, col = rgb(1, 1, 1, 0.8), border = NA)
  text((n + 1) / 2, 1, labels = attr(x, "name"), cex = 1, family = "serif")
}
