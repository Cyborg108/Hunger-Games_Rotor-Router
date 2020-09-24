︠810fd88a-a013-47fe-a2c4-322d56dab540s︠
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
︡c787ce40-892f-4975-bcc9-d09dca1f6c93︡{"done":true}
︠0043e430-0228-4526-bffd-7d34aaea4476︠

H = [[-2/3, 1/3, 1/3], [1/3, -2/3, 1/3], [1/3, 1/3, -2/3]]
shape = []
basin = shapeSearch(-0.7,0.7,-0.7,0.7,0.005)
basin.show(gridlines="minor")
︡58bc059b-f6cc-4a40-b730-df6ac0f7add4︡{"file":{"filename":"/home/user/.sage/temp/project-4a96ac48-7429-46a5-9888-4355fa03fe58/533/tmp_94a3Ra.svg","show":true,"text":null,"uuid":"79a432ef-5373-4cf8-bdae-10ca56ebf5df"},"once":false}︡{"done":true}
︠1715f649-1393-4c78-9aff-0195b6a7367fs︠


H = [[-1, 1/2, 1/2], [1/2, -1, 1/2], [1/2, 1/2, -1]]
shape = []
basin = shapeSearch(-1,1,-1,1,0.01)
basin.show(gridlines="minor")
︡3bd0dc32-1aaf-4cb9-b3ef-c25100533949︡{"file":{"filename":"/home/user/.sage/temp/project-4a96ac48-7429-46a5-9888-4355fa03fe58/533/tmp_acBgyG.svg","show":true,"text":null,"uuid":"3b28a7c7-1907-4da5-a4a1-da15e6bc2e12"},"once":false}︡{"done":true}









