cvx_begin
    variable x(n)
    minimize(A * x - b)
    subject to
        C * x == d
        norm( x ) <= e
cvx_end