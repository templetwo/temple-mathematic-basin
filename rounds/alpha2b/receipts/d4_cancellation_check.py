import numpy as np, itertools
rng=np.random.default_rng(7)
def box(R): return [k for k in itertools.product(range(-R,R+1),repeat=3)]
def leray(k,w):
    k=np.array(k,float); ks=k@k
    return w if ks==0 else w-(k@w)/ks*k
def field(B,v):
    S=set(B); N={}
    for k in B:
        acc=np.zeros(3,complex)
        for p in B:
            q=tuple(np.array(k)-np.array(p))
            if q in S: acc+= 1j*(np.array(q,float)@v[p])*v[q]   # raw advective form, p,q in B, k in B
        N[k]=leray(k,acc)
    return N
def sample(B, incompressible=True, reality=True):
    v={k:(rng.normal(size=3)+1j*rng.normal(size=3)) for k in B}
    if reality:
        for k in B:
            mk=tuple(-np.array(k))
            if mk in v: v[mk]=np.conj(v[k])
    if incompressible:
        for k in B: v[k]=leray(k,v[k])
    return v
def rate(B,v):
    N=field(B,v); return sum(np.vdot(v[k],N[k]) for k in B)
B=box(1)
for inc,real,label in [(True,True,'incompressible+reality+symmetric box'),(False,True,'reality only'),(True,False,'incompressible only')]:
    T=rate(B,sample(B,inc,real)); print(f"{label:40s} Re<v,N> = {T.real:+.3e}   |<v,N>| = {abs(T):.3e}")
Basym=[k for k in B if k!=(1,1,1)]; T=rate(Basym,sample(Basym,True,True)); print(f"{'incompressible+reality, ASYMMETRIC box':40s} Re<v,N> = {T.real:+.3e}")
B2=box(2); T=rate(B2,sample(B2,True,True)); print(f"{'box R=2 (125 modes), inc+real+sym':40s} Re<v,N> = {T.real:+.3e}   |<v,N>| = {abs(T):.3e}")
def skew_field(B,v):
    S=set(B); N={}
    for k in B:
        acc=np.zeros(3,complex)
        for p in B:
            q=tuple(np.array(k)-np.array(p))
            if q in S: acc+=0.5j*((np.array(q,float)@v[p])*v[q]-(np.array(p,float)@v[q])*v[p])
        N[k]=leray(k,acc)
    return N
v=sample(B,True,True); Ns=skew_field(B,v); print("grok #18828 'skew form' as written: max |N_k| over box =", max(np.linalg.norm(Ns[k]) for k in B))
