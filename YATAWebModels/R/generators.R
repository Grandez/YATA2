makePoints = function(size=100) {
 rpar = 50
  # Start
  r1 =  sample(100:150, 10, replace=TRUE)
  idx = sample(1:10, 1)
  # Plus/Minus
  ud = sample(c(-1,1),size,replace=TRUE)
  #values
  v1 = runif(n = size, min = 0, max = 1)
  v1 = round(v1,3)
  var = v1 * ud / 10
  dat = rep(r1[idx], size)
  for (i in 1:(size-1)) {
      dat[i+1] = dat[i] * (1 + var[i])
  }
  data.frame(x=seq(1,size), y=dat)
}

makePlot = function(df, color, base) {
     p = ggplot(data=df) + geom_point(aes(x,y)) + theme_bw()
     if (!missing(base)) p = base + p
     m = nrow(df)
     p = p + geom_segment(aes(x=df[1,1], y=df[1,2], xend=df[m,1], yend=df[m,2], colour=color))
     plot = Plot$new(df,p,calcRect(df))
     plot$tg = calcSlope(plot)
     plot
}
addSegment = function (model) {
  m = nrow(model$dfw)
  p = model$plots[[model$step + 1]]
  model$plots[[model$step + 2]] = p + geom_segment(aes(x=model$dfw[1,1], y=model$dfw[1,2], xend=model$dfw[m,1], yend=model$dfw[m,2], colour=model$color))
  eq = calcRect(model$dfw)
  model$equs[[model$step + 2]] = eq
}
calcRect = function(df) {
  x1 = df[1,1]
  y1 = df[1,2]
  x2 = df[nrow(df),1]
  y2 = df[nrow(df),2]

  xr = x2 - x1
  yr = y2 - y1
  B = ((y1 * xr) - (x1 * yr)) / xr
  A = yr / xr
  list(a=A,b=B)
}

calcSlope = function(model) {
    dfw = model$df
    dfw$y = dfw$y - model$beta
    size = nrow(dfw)
    dfw$x = dfw$x / size
    dfw$y = dfw$y / size
    parms = calcRect(dfw)
    atan(parms$a) * 180 / pi
}

rotate = function() {
    cang = cos(alpha * pi / 180) * 180 / pi
    sang = sin(alpha * pi / 180) * 180 / pi
    df$x1 = (df$x * cang) + (df$y * sang)
    df$y1 = (df$x * sang * -1) + (df$y * cang)
    # grados * pi / 180

}

# x'=x\cos \theta +y\sin \theta
# y ′ = − x sin ⁡ θ + y cos ⁡










