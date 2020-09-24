︠a14651b6-b871-4df8-b31a-e3c0c91af769s︠
import matplotlib
import matplotlib.pyplot as plt

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

def recurChip(h,ins):
    hist = [];
    hist.append(h)
    h2 = h
    h2 = plusChip(h2,ins)
    while h2 not in hist:
        hist.append(h2)
        h2 = plusChip(h2,ins)
    return tuple(hist[hist.index(h2):])


def allInsRecur(h):
    recurrents = [];
    for i in range(len(H)):
        if i not in absorb:
            recurrents.extend(x for x in recurChip(h,i) if x not in recurrents)
    return tuple(recurrents)

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
def allRecur(h=(0,)*len(H),net=100):
    recurrents = [];
#     recurrents.append(h)
    queue = set(allInsRecur(h))
    while len(queue) > 0:
        candidate = queue.pop()
        if candidate not in recurrents:
            if recurCheck(candidate,net):
                recurrents.append(candidate)
                queue.update(allInsRecur(candidate))
    return tuple(recurrents)

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


︡06ec1b54-a6dd-4688-8696-92e2849ba37e︡{"done":true}
︠22c3d9ad-a6ff-40e5-be0c-515fc71ab348s︠
H = ((-1, 0.4, 0.6),
    (0.2, -0.6, 0.4),
    (0.2, 0.2, -0.4))
absorb=(2,)
fig = plotRecur2D(-1,1,0.02)
fig.show(gridlines='minor')
︡77e180b6-3114-41fa-91ab-ba7adda30513︡{"file":{"filename":"/home/user/.sage/temp/project-4a96ac48-7429-46a5-9888-4355fa03fe58/602/tmp_y4VdAG.svg","show":true,"text":null,"uuid":"d7f45499-3cdf-450b-a44b-ed085291cf17"},"once":false}︡{"done":true}
︠cb6994eb-7241-4503-9c4d-b0664006f8e1s︠
H = ((-1, 0.4, 0.6),
    (0.2, -0.6, 0.4),
    (0.2, 0.2, -0.4))
absorb=(2,)
fig = plotRecur2D(-0.7,0.8,0.005)
fig.show(gridlines='minor')
︡810bf858-307b-484d-a805-e6ca2e1bcc04︡
︠d5eb45d8-579d-4ea2-a5bd-2d7f772fe421s︠
H = ((-1, 0.4, 0.6),
    (0.2, -0.6, 0.4),
    (0.2, 0.2, -0.4))
absorb=(2,)
# (0,0,0) in allRecur()
# n = 20
# while recurCheck((0,)*len(H),n):
#     n -= 1
# n=3 is largest value at which recurCheck net will fail for 0
# print(n)
fig = recurSearch(-0.7,0.8,0.005,net=10)
scatter_plot(fig, markersize=5, alpha=0.5, zorder=0,gridlines='minor')
︡b150925d-34d8-4e0e-abfa-d5ce8618a086︡{"file":{"filename":"/home/user/.sage/temp/project-4a96ac48-7429-46a5-9888-4355fa03fe58/731/tmp_hUwrZC.svg","show":true,"text":null,"uuid":"d72210df-f64c-4de4-8398-2f3163ac619d"},"once":false}︡{"done":true}
︠aac96b4b-a743-4124-a056-d75823122d9d︠









