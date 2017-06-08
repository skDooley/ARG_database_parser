#' Hi resolution Png images
#' 
#' This function will create a high resolution .png image of a figure that can be used for publications.
#' @param .. In the brackets should go the path and filenaame the image will be saved to in "".
#' @keywords bins
#' @export
#' @examples
#' Png("path/to/file/name.png")
#' plot()
#' dev.off()


Png <- function(..., width=8, height=8, res=300){
  png(..., width=width*res, height=height*res, res=res)
}
