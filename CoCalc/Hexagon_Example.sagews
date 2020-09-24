︠3ca69fec-b054-41b4-933d-fcde10e116cds︠
H = [[-0.2, 0.2, 0], [0.2, -0.6, 0.4], [0.6, 0.4, -1]]
shape = []

def fire(h):
    norm = [0,0,0]
    for i in range(3):
        norm[i] = abs(h[0]+H[i][0]) + abs(h[1]+H[i][1]) + abs(h[2]+H[i][2])
    firevec = 0;
    for i in range(3):
        if norm[i] < norm[firevec]:
            firevec = i
    h2 = [0,0,0]
    for i in range(3):
        h2[i] = h[i] + H[firevec][i]
    return h2

def fixed(h):
    h2 = h
    for i in range(18):
        h2 = fire(h2)
    eq = True
    for i in range(3):
        eq = eq and (abs(h2[i]-h[i])<0.01)
    return eq

def shapeSearch(xmin,xmax,ymin,ymax, res):
    i = xmin
    while i <= xmax:
        j = ymin
        while j <= ymax:
            h = [i,j,-i-j]
            if fixed(h):
                shape.append([round(i,3),round(j,3)])
            j += res
        i += res
    return scatter_plot(shape, markersize=5, alpha=0.5, zorder=0)

_ = shapeSearch(-0.8,0.6,-0.5,0.8,0.005)
_ = shapeSearch(-0.1,0.2,0.6,0.8,0.001)
basin = shapeSearch(-0.55,-0.35,-0.35,-0.15,0.001)
basin.show(gridlines="minor")
︡0bc58dd5-0b27-493e-b7e4-c16e3b3cbdad︡{"file":{"filename":"/home/user/.sage/temp/project-4a96ac48-7429-46a5-9888-4355fa03fe58/410/tmp_XKYo48.svg","show":true,"text":null,"uuid":"5c9d9ea4-36d3-4663-b2f5-ef890a57fa40"},"once":false}︡{"done":true}









