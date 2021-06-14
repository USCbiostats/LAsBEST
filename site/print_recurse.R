cat("You can also check the list of shared files in our repository's [Google Drive folder](https://github.com/USCBiostats/LAsBEST/tree/main/google-drive)\n\n")

wpath <- "https://github.com/USCbiostats/LAsBEST/raw/main/%s"

print_recurse <- function(f) {
  
  if (length(f) == 0)
    return(invisible(0))
  
  for (i in f) {
    
    # Getting the name
    fname <- gsub(".+/([^/]+)$", "\\1", normalizePath(i))
    
    # If it is a directory
    if (file_test("-d", i)) {
      
      fs <- list.files(i, full.names = TRUE)
      cat("## Contents of", fname, "\n\n")
      print_recurse(fs)
      
    } else {
      
      urllink <- sprintf(wpath, i)
      cat(sprintf('* <a href="%s" target="_blank">%s</a>\n\n', urllink, fname))
      
    }
    
  }
  
  return(invisible(0L))
  
}