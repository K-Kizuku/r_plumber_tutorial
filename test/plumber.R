#
# This is a Plumber API. You can run the API by clicking
# the 'Run API' button above.
#
# Find out more about building APIs with Plumber here:
#
#    https://www.rplumber.io/
#

library(plumber)
library(ggplot2)
library(jsonlite)
library(readxl)

#* @apiTitle Plumber Example API
#* @apiDescription Plumber example description.

#* @filter cors
cors <- function(res) {
  res$setHeader("Access-Control-Allow-Origin", "*")
  plumber::forward()
}

#* Echo back the input
#* @param msg The message to echo
#* @get /echo
function(msg = "") {
    list(msg = paste0("The message is: '", msg, "'"))
}

#* Plot a histogram
#* @serializer png
#* @param s number
#* @get /plot
function(s = 0) {
    rand <- rnorm(s)
    hist(rand)
}

#* Plot a histogram
#* @serializer png
#* @param s number
#* @get /test_data
function(s = 0) {
  C014_AFB_KEN <- read_excel("C014_AFB_KEN.xls")
  # str(C014_AFB_KEN)
  p_0 <- ggplot(data = C014_AFB_KEN, mapping = aes(x = 年齢階級, y = 健診受診者数)) + geom_point()
  print(p_0)
}

#* Plot a histogram
#* @serializer json
#* @get /graph
#* @options /graph
cors_disabled <- function() {
  # ggplot2でグラフを描画する
  p <- ggplot(mtcars, aes(x = mpg, y = hp)) +
    geom_point()
  
  # ggplot2のグラフオブジェクトをリストオブジェクトに変換する
  p_list <- ggplot_build(p)
  
  # リストオブジェクトをJSON形式に変換する
  p_json <- toJSON(p_list$data)
  return(p_json)
}

#* Return the sum of two numbers
#* @param a The first number to add
#* @param b The second number to add
#* @post /sum
function(a, b) {
    as.numeric(a) + as.numeric(b)
}

# Programmatically alter your API
#* @plumber
function(pr) {
    pr %>%
        # Overwrite the default serializer to return unboxed JSON
        pr_set_serializer(serializer_unboxed_json())
}
