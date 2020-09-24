︠a14651b6-b871-4df8-b31a-e3c0c91af769︠
def fire(h):
    firevec = 0;
    for i in range(len(H)):
        if h[i] > h[firevec]:
            firevec=i
    h2 = [0] * len(H)
    if firevec in absorb:
        h2 = list(h)
        h2[firevec] -= 1
        return tuple(h2), True
    for i in range(len(H)):
        h2[i] = h[i] + H[firevec][i]
        h2[i] = round(h2[i],3)
    return tuple(h2), False

def plusChip(h,ins):
    h2 = [0] * len(H)
    for i in range(len(H)):
        h2[i] = h[i] + H[ins][i]
        h2[i] = round(h2[i],3)
    h2[ins] += 1
    h2[ins] = round(h2[ins],3)
    h2, absorbed = list(fire(h2))
    while not absorbed:
        h2, absorbed = list(fire(h2))
    return tuple(h2)

# primitive reachable check from h1 to h2, within net number of moves
def reachable(h1,h2,net=100):
    reach = {h1}
    for time in range(net):
        reach2=[];
        for i in range(len(H)):
            if i not in absorb:
                for h in reach:
                    reach2.append(plusChip(h,i))
        reach = set(reach2)
        if h2 in reach:
            return True
    return False

# more exhaustive recurrence check
def recurCheck(h,net=100):
    recurrent = True
    for i in range(len(H)):
        if i not in absorb:
            recurrent = recurrent and reachable(plusChip(h,i),h,net)
    return recurrent

def recurSearch(hmin,hmax, res, indx=0, indy=1,net=100):
    def genH(hmin,hmax,res):
        diff = hmax - hmin
        h = [hmin]*len(H)
        h = [round(i,3) for i in h]
        if sum(h)==0:
            yield tuple(h)
        while sum(h) < hmax * len(H):
            h[-1] += res
            for i in range(1,len(H)):
                if h[-i] > hmax:
                    h[-i] -= diff
                    h[-i-1] += res
            h = [round(i,3) for i in h]
            if sum(h)==0:
                yield tuple(h)
    shape = []
    for h in genH(hmin,hmax,res):
        if recurCheck(h,net):
            shape.append(tuple(h))
    return tuple(shape)


# x = []
# for h in shape:
#     x.append([h[indx],h[indy]])
# return scatter_plot(x, markersize=5, alpha=0.5, zorder=0)

H = ((-0.5, 0.4, 0, 0.5),
    (0.5, -1, 0, 0.5),
    (0.5, 0, -1, 0.5),
    (0, 0.5, 0, -1))
absorb=(0,1,3)

# fig = recurSearch(-1,1,0.01,net=3)
fig
# scatter_plot(fig, markersize=5, alpha=0.5, zorder=0,gridlines='minor')
︡ff8119e3-424c-4734-8dc7-af9bd15fd65f︡









