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

fixed([-0.699,0.399,0.3])
fixed([0.101,0.399,-0.5])
fixed([-0.066,0.7326667,-0.6666667])
fixed([0,0.699,-0.699])
fixed([0.1,0.599,-0.699])
fixed([0.3,0.199,-0.499])
fixed([0.49,0.005,-0.495])
fixed([0.3,0.01,-0.301])
fixed([0.498,-0.399,-0.099])
fixed([-0.3,-0.4,0.7])
fixed([-0.4,-0.3,0.7])
fixed([-0.46666666,-0.26666666,0.46666666+0.26666666])
fixed([-0.49,-0.205,0.695])
fixed([-0.299,-0.2,0.499])
fixed([-0.499,0,0.499])
︡547b9081-03e9-4338-b50c-84bb92a7cf5f︡{"stdout":"True\n"}︡{"stdout":"True\n"}︡{"stdout":"True\n"}︡{"stdout":"True\n"}︡{"stdout":"True\n"}︡{"stdout":"True\n"}︡{"stdout":"True\n"}︡{"stdout":"True\n"}︡{"stdout":"True\n"}︡{"stdout":"True\n"}︡{"stdout":"True\n"}︡{"stdout":"True\n"}︡{"stdout":"True\n"}︡{"stdout":"True\n"}︡{"stdout":"True\n"}︡{"done":true}









