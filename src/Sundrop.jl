function Sundrop(sp::SurplusProcess,u_0::Numbers)
Compose.compose(context(),
        (context(1-SurPro(sp,u_0,Exp),1-SurPro(sp,u_0,Exp),0.1,0.1), circle(), fill("bisque")),
        (context(1-SurPro(sp,u_0,FG),1-SurPro(sp,u_0,FG),0.1,0.1), circle(), fill("orange")),
        (context(1-SurPro(sp,u_0,MixExp),1-SurPro(sp,u_0,MixExp),0.1,0.1), circle(), fill("black")), 
        context(), rectangle(), fill("tomato"))
end
