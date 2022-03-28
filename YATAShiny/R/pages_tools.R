old_markTabAsSelected <- function(x) {
  attr(x, "selected") <- TRUE
  x
}
old_anyNamed = function (x) {
    if (length(x) == 0)
        return(FALSE)
    nms <- names(x)
    if (is.null(nms))
        return(FALSE)
    any(nzchar(nms))
}
old_withPrivateSeed = function (expr) {
    .globals = list() # No tenemos .globals
    if (exists(".Random.seed", envir = .GlobalEnv, inherits = FALSE)) {
        hasOrigSeed <- TRUE
        origSeed <- .GlobalEnv$.Random.seed
    }
    else {
        hasOrigSeed <- FALSE
    }

    if (is.null(.globals$ownSeed)) {
        if (hasOrigSeed) {
            rm(.Random.seed, envir = .GlobalEnv, inherits = FALSE)
        }
    }
    else {
        .GlobalEnv$.Random.seed <- .globals$ownSeed
    }
    on.exit({
        .globals$ownSeed <- .GlobalEnv$.Random.seed
        if (hasOrigSeed) {
            .GlobalEnv$.Random.seed <- origSeed
        } else {
            rm(.Random.seed, envir = .GlobalEnv, inherits = FALSE)
        }
        httpuv::getRNGState()
    })
    expr
}
old_randomInt <- function(min, max) {
  if (missing(max)) {
    max <- min
    min <- 0
  }
  if (min < 0 || max <= min)
    stop("Invalid min/max values")

  min + sample(max-min, 1)-1
}
old_p_randomInt = function (...) {
    old_withPrivateSeed(randomInt(...))
}
old_isTabSelected <- function(x) {
  isTRUE(attr(x, "selected", exact = TRUE))
}

# Returns the icon object (or NULL if none), provided either a
# tabPanel, OR the icon class
old_getIcon <- function(tab = NULL, iconClass = NULL) {
  if (!is.null(tab)) iconClass <- tab$attribs$`data-icon-class`
  if (!is.null(iconClass)) {
    if (grepl("fa-", iconClass, fixed = TRUE)) {
      # for font-awesome we specify fixed-width
      iconClass <- paste(iconClass, "fa-fw")
    }
    icon(name = NULL, class = iconClass)
  } else NULL
}
