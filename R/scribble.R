#' @title Scribble
#'
#' @description `Scribble` provides a set of tools to allow you to mark up
#'   your `xaringan` slides. Click the "edit" icon to begin drawing. Use the
#'   eraser to remove select markup, or the trash to clear the entire
#'   canvas. NOTE: You will not be able to navigate slides while in draw or
#'   erase mode.
#'
#' @details You may toggle the visibility of the `Scribble` toolbox by pressing
#'   **S** at any time. Markup will persist when changing slides as long as the
#'   canvas isn't cleared. You may save a permanent copy of the slides with the
#'   markup by saving your presentation (e.g. using Chrome > File > Print).
#'
#' @return An `htmltools::tagList()` with the scribble dependencies, or an
#'   [htmltools::htmlDependency()].
#' @section Usage: To add `Scribble` to your `xaringan` presentation,
#'   add the following code chunk to your slides' R Markdown file.
#'
#'   ````markdown
#'   ```{r xaringan-scribble, echo=FALSE}
#'   xaringanExtra::use_scribble()
#'   ```
#'   ````
#'
#' @name scribble
NULL

#' @describeIn scribble Adds `Scribble` to your xaringan slides.
#' @export
use_scribble <- function(
	pen_color = "rgba(0, 0, 0, 1)",
	pen_size = 3,
	eraser_color = "rgba(0, 0, 0, 0.6)",
	eraser_size = 50
) {
	htmltools::tagList(
		html_dependency_fabricjs(),
		html_dependency_scribble(
			pen_color,
			pen_size,
			eraser_color,
			eraser_size
		)
	)
}

#' @describeIn scribble Returns an [htmltools::htmlDependency()] with the
#'   `fabric.js` dependencies for use in xaringan and R Markdown documents.
#'   Most users will want to use `use_scribble()` instead.
#' @export
html_dependency_fabricjs <- function() {
	htmltools::htmlDependency(
		name = "fabric",
		version = "4.3.1",
		package = "xaringanExtra",
		src = "scribble",
		script = "fabric.min.js",
		all_files = FALSE
	)
}

#' @describeIn scribble Returns an [htmltools::htmlDependency()] with the
#'   `Scribble` dependencies for use in xaringan and R Markdown documents. Most
#'   users will want to use `use_scribble()` instead.
#'
#' @param pen_color Pen color (default is "black").
#'   Users may choose any valid CSS Hex, RGB, or HSL color.
#' @param pen_size Pen size (default is 3).
#' @param eraser_color Eraser color (default is "translucent black").
#'   Users may choose any valid CSS Hex, RGB, or HSL color.
#' @param eraser_size Eraser size (default is 50).
#'
#' @export
html_dependency_scribble <- function(
	pen_color,
	pen_size,
	eraser_color,
	eraser_size
) {
	htmltools::htmlDependency(
		name = "xaringanExtra-scribble",
		version = "0.0.1",
		package = "xaringanExtra",
		src = "scribble",
		script = "xaringanExtra-scribble.js",
		stylesheet = "xaringanExtra-scribble.css",
		head = init_Scribble(pen_color, pen_size, eraser_color, eraser_size),
		all_files = FALSE
	)
}

init_Scribble <- function(
	pen_color,
	pen_size,
	eraser_color,
	eraser_size
) {
	stopifnot(is.numeric(pen_size))
	stopifnot(is.numeric(eraser_size))
	opts <- list(
		pen_color = pen_color,
		pen_size = jsonlite::unbox(pen_size),
		eraser_color = jsonlite::unbox(eraser_color),
		eraser_size = jsonlite::unbox(eraser_size)
	)
	opts <- jsonlite::toJSON(opts)

	sprintf(
		"<script>document.addEventListener('DOMContentLoaded', function() { window.xeScribble = new Scribble(%s) })</script>",
		opts
	)
}