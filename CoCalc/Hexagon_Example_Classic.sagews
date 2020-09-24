︠3ca69fec-b054-41b4-933d-fcde10e116cds︠
H = [[-0.2, 0.2, 0], [0.2, -0.6, 0.4], [0.6, 0.4, -1]]
shape = []

# Using the classic hunger game rules
def fire(h):
    firevec = 0;
    for i in range(3):
        if h[i] > h[firevec]:
            firevec=i
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

basin = shapeSearch(-0.3,0.9,-0.7,0.7,0.005)
# _ = shapeSearch(0.2,0.7,0.6,0.8,0.001)
# basin = shapeSearch(-0.55,-0.35,-0.35,-0.15,0.001)
basin.show(gridlines="minor")
︡354a2731-9d0e-47c4-ab00-43a4cbe03785︡{"file":{"filename":"/home/user/.sage/temp/project-4a96ac48-7429-46a5-9888-4355fa03fe58/638/tmp_kvvDfl.svg","show":true,"text":null,"uuid":"0f6c25f1-eb43-40df-9d7a-96323e2fba44"},"once":false}︡{"done":true}









