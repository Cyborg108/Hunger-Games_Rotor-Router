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

# def recurChip(h,ins):
#     hist = [];
#     hist.append(h)
#     h2 = h
#     h2 = plusChip(h2,ins)
#     while h2 not in hist:
#         hist.append(h2)
#         h2 = plusChip(h2,ins)
#     return tuple(hist[hist.index(h2):])


# def allInsRecur(h):
#     recurrents = [];
#     for i in range(len(H)):
#         if i not in absorb:
#             recurrents.extend(x for x in recurChip(h,i) if x not in recurrents)
#     return tuple(recurrents)

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

# primitive recurrence check (necessary criteria but might not be sufficient)
# def recurCheck(h):
#     recurrent = True
#     for i in range(len(H)):
#         if i not in absorb:
#             recurrent = recurrent and (h in recurChip(h,i))
#     return recurrent

# more exhaustive recurrence check
def recurCheck(h,net=100):
    recurrent = True
    for i in range(len(H)):
        if i not in absorb:
            recurrent = recurrent and reachable(plusChip(h,i),h,net)
    return recurrent

# Searches through all recurrent configurations reachable by a given recurrent configuration, by default all-zero which sometimes isn't recurrent
# Note that this only looks at recurrent configuration reachable by a given configuration.
# def allRecur(h=(0,)*len(H),net=100):
#     recurrents = [];
# #     recurrents.append(h)
#     queue = set(allInsRecur(h))
#     while len(queue) > 0:
#         candidate = queue.pop()
#         if candidate not in recurrents:
#             if recurCheck(candidate,net):
#                 recurrents.append(candidate)
#                 queue.update(allInsRecur(candidate))
#     return tuple(recurrents)

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

# Plots all recurrent configurations with total hunger 0
def plotRecur2D(hmin,hmax, res, indx=0, indy=1,net=100):
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
    x = []
    for h in shape:
        x.append([h[indx],h[indy]])
    return scatter_plot(x, markersize=5, alpha=0.5, zorder=0)

H = ((-0.5, 0.4, 0, 0.5),
    (0.5, -1, 0, 0.5),
    (0.5, 0, -1, 0.5),
    (0, 0.5, 0, -1))
absorb=(0,1,3)
# n = 20
# plusChip((0,)*len(H),2)
# plusChip((-0.5,0,0,0.5),2)
# while recurCheck((0,)*len(H),n):
#     n -= 1
# n=0 is largest value at which recurCheck net will fail for 0
# print(n)
# fig = recurSearch(-1,1,0.1,net=3) # returns tuple with 620 elements
# fig = recurSearch(-1,1,0.05,net=3) # returns tuple with 5434 elements
# fig = recurSearch(-1,1,0.01,net=3) # returns tuple with 345801 elements
# scatter_plot(fig, markersize=5, alpha=0.5, zorder=0,gridlines='minor')
︡ff8119e3-424c-4734-8dc7-af9bd15fd65f︡









