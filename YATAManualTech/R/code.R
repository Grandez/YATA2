table_declarations = function(data, caption=NULL) {
   data[[2]] = gsub("[ \t]+", " ", data[[2]])
   data[[2]] = gsub("\\n", "<br>", data[[2]])
   df = do.call(rbind.data.frame, data)

  df %>% kbl(caption = caption) %>% 
         kable_classic()   
}