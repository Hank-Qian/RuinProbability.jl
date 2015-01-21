function Sundrop(sp::SurplusProcess)
Compose.compose(context(),
        (context(SurPro(sp,Exp),SurPro(sp,Exp),0.1,0.1), circle(), fill("bisque")),
        (context(SurPro(sp,FG),SurPro(sp,FG),0.1,0.1), circle(), fill("orange")),
        (context(SurPro(sp,MixExp),SurPro(sp,MixExp),0.1,0.1), circle(), fill("black")), 
        context(), rectangle(), fill("tomato"))
end
