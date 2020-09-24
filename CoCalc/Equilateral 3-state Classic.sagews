︠b9c78142-c5ad-4992-86ce-e48aa55410e4s︠
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

︡16f61e5a-0d7c-45c5-ab13-9f55cd683a19︡{"done":true}
︠1c0f073f-9ae8-4795-9dde-842ffc8b878bs︠

H = [[-1, 1/2, 1/2], [1/2, -1, 1/2], [1/2, 1/2, -1]]
shape = []
basin = shapeSearch(-1,1,-1,1,0.01)
basin.show(gridlines="minor")
︡0feddd96-2473-42d2-9b58-53193b4c5f4f︡{"file":{"filename":"/home/user/.sage/temp/project-4a96ac48-7429-46a5-9888-4355fa03fe58/486/tmp_GNHA4O.svg","show":true,"text":null,"uuid":"244f9cb9-fc72-4846-aeb8-cf8b98e646c8"},"once":false}︡{"done":true}









