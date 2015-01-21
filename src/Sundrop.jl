function Sundrop(sp::SurplusProcess)
Compose.compose(context(),
        (context(1-SurPro(sp,Exp),1-SurPro(sp,Exp),0.1,0.1), circle(), fill("bisque")),
        (context(1-SurPro(sp,FG),1-SurPro(sp,FG),0.1,0.1), circle(), fill("orange")),
        (context(1-SurPro(sp,MixExp),1-SurPro(sp,MixExp),0.1,0.1), circle(), fill("black")), 
        context(), rectangle(), fill("tomato"))
end
