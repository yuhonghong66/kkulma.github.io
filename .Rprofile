build_article <- function(filename) {
  knitr::opts_knit$set(base.url = "/")
  knitr::render_markdown()
  
  d = gsub('^_|[.][a-zA-Z]+$', '', filename)
  knitr::opts_chunk$set(
    fig.path   = sprintf('img/%s/', d),
    cache.path = sprintf('cache/%s/', d),
    screenshot.force = FALSE
  )
  knitr::opts_knit$set(width = 70)
  
  source = paste0('blog_prep/', filename, '.Rmd')
  dest = paste0('_posts/', filename, '.md')
  
  knitr::knit(source, dest, quiet = TRUE, encoding = 'UTF-8', envir = .GlobalEnv)
  brocks::htmlwidgets_deps(source, always = TRUE)
  
  # brocks removes the date... but this blog uses the date on the url... so rename it back :shrug:
  lose_date <- function(x) {
    gsub("^[[:digit:]]{4}-[[:digit:]]{2}-[[:digit:]]{2}-", 
         "", x)
  }
  
  wrong_name = gsub(".Rmd$", ".html", lose_date(basename(source)))
  right_name = gsub(".Rmd$", ".html", basename(source))
  success = file.rename(paste0('_includes/htmlwidgets/', wrong_name), paste0('_includes/htmlwidgets/', right_name))
}
