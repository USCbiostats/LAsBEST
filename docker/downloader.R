downloader <- function(id) {
  if (inherits(id, "character"))
    id <-
      googledrive::drive_ls(googledrive::drive_get(id = id))
  
  if (nrow(id) == 0) {
    message("\tEmpty folder")
    return(NULL)
  }
  
  ans <- NULL
  for (i in 1:nrow(id)) {
    # print(id[i,,drop=FALSE])
    
    if (googledrive::is_folder(id[i, , drop = FALSE])) {
      message("mkdir ", id[i, 1])
      ans <-
        rbind(ans, reader(googledrive::drive_ls(id[i, , drop = FALSE])))
    }
    
    message("cp file", id[i, 1])
    ans <- rbind(ans, id[i, ])
    
  }
  
  ans
  
}
