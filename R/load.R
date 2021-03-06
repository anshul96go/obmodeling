#' @rdname load.trades
#' @export
load.quotes <- function(filename, symbol.col='X.RIC', tz='GMT' , format="%d-%b-%Y %H:%M:%OS", ...) {
  .ob <- getOB()
  raw.csv <- read.csv(filename, ...=...)
  symbols <- split(raw.csv, raw.csv[,symbol.col])
  xts.data <- lapply(symbols, function(x) {
    tmp <- paste(x$Date.G., x$Time.G.)
    time <- as.POSIXct(tmp, tz=tz, format=format)
    out <- xts(x[, 6:ncol(x)], order.by=time)
    class(out) <- c('ob.quotes','xts','zoo')
    out
  })
  names(xts.data) <- names(symbols)
  for(symbol in names(xts.data)) {
    .ob[[symbol]]$quotes <- new.env()
    .ob[[symbol]]$quotes <- xts.data[[symbol]]
  }
}

###############################################################################
# obmodeling: Parsing, analysis, visualization of L1 and L2 order book data
# Copyright (c) 2017- Jeffrey Mazar and Brian G. Peterson
#
# This library is distributed under the terms of the GNU Public License (GPL)
# for full details see https://www.gnu.org/licenses/licenses.en.html
#
###############################################################################

