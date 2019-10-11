#' Plot historical events in the chronology they happened
#'
#' @param tidy_df dataframe in tidy format with three columns \code{1. year (numeric), 2.
#'   events to be plotted in upper panel (character), 3. events to be plotted in lower
#'   panel (character)} Each year should be unique
#' @param text logical, to plot the events as text or boxed labels; default: TRUE
#' @param horizontal logical, to plot the events in horizontal direction or vertials; default: TRUE
#' @import ggplot2
#' @import dplyr
#' @import rlang
#' @return
#' @export
#'
#' @examples
chronological_timeline_horizontal <- function(tidy_df, text=TRUE, horizontal=TRUE){

         names(tidy_df) <- c("year", "upper", "lower")
           tidy_timeline <- tidy_df %>% dplyr::arrange(year) %>%
                    dplyr::mutate(previous_year= dplyr::lag(year, default=rlang::as_double(year)[1]),
                                  difference=year-previous_year,
                                  ratio_1=dplyr::if_else(year!=previous_year, tidyr::replace_na(year/previous_year,0),0),
                                  ratio=cumsum(ratio_1)) %>%
                    dplyr::select(-c("ratio_1", "difference", "previous_year")) %>% # compute proportion i.e higher value for higher difference
                    tidyr::gather(position, events,-year, -ratio) %>%
                    dplyr::mutate(y_axis=if_else(position=="upper", seq(0.5,nrow(dd),by = 0.5), seq(-nrow(dd),-0.5,by = 0.5)))


         direction <- dplyr::if_else(horizontal==TRUE, "x", "y")

          if(text==TRUE){

                    message("plotting text ....")
                  gg <- ggplot2::ggplot(tidy_timeline, aes(ratio, 0, label=events, color=factor(year)))+
                              ggplot2::geom_point(aes(ratio, y_axis))+
                              ggplot2::geom_hline(yintercept = 0, color="grey")+
                              ggplot2::geom_segment(aes(y=y_axis,yend=0, xend=ratio))+
                              ggrepel::geom_text_repel(aes(y=if_else(y_axis >0, y_axis+0.2,y_axis-0.2),
                                                       label=events),
                                                       direction=direction,size=3, show.legend = FALSE)+
                              ggplot2::geom_text(aes(x=ratio,y=0.2,label=year, fontface="bold"),size=2.5, color='black')+
                              timeline_theme()

          }
          else{
                    message("plotting label ....")
             gg <-   ggplot2::ggplot(tidy_timeline, aes(ratio, 0, label=events, color=factor(year)))+geom_point(aes(ratio, y_axis))+
                              ggplot2::geom_hline(yintercept = 0, color="grey")+
                              ggplot2::geom_segment(aes(y=y_axis,yend=0, xend=ratio))+
                              ggrepel::geom_label_repel(aes(y=if_else(y_axis >0, y_axis+0.2,y_axis-0.2),label=events),
                                                        direction=direction,size=3, show.legend = FALSE)+
                              ggplot2::geom_text(aes(x=ratio,y=0.2,label=year, fontface="bold"),size=2.5, color='black')+
                              timeline_theme()
          }


         if(horizontal==TRUE){
                   gg <- gg
                  }
         if(horizontal==FALSE) {
                   gg <- gg+coord_flip()
                   }


         print(gg)


}



