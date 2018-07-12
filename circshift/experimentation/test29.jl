N = 16
I = eye(N)

Is = map(x -> circshift(I, (x, 0)), 0:9)

W = map(x -> parse(x), ARGS)
