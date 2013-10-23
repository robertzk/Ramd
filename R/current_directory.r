current_directory <-
  (function(frames = sys.frames()) {
    # http://stackoverflow.com/questions/1815606/rscript-determine-path-of-the-executing-script
    frame_files <- Filter(Negate(is.null), lapply(frames, function(x) x$ofile))
    dirname(frame_files[[length(frame_files)]])
  })

