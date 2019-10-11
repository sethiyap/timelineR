
#' ggplot theme for timeline plot
#' @import ggplot2
#' @return
#'
#'
#' @examples
timeline_theme <- function(){

          ggplot2::theme_classic()+
                    ggplot2::theme(axis.line.y=element_blank(),
                                   axis.text.y=element_blank(),
                                   axis.title.x=element_blank(),
                                   axis.title.y=element_blank(),
                                   axis.ticks.y=element_blank(),
                                   axis.text.x =element_blank(),
                                   axis.ticks.x =element_blank(),
                                   axis.line.x =element_blank(),
                                   legend.position = "none"
                    )
}
