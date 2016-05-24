cacheSolve <- function(m, ...) {
  inv <- m$getinverse()
  if(!is.null(inv)) {
    message("getting cached inverse")
    return(inv)
  }
  A <- m$get()
  inv <- solve(A, ...)
  m$setinverse(inv)
  inv
}