/* Initial beliefs and rules */
random_dir(DirList,RandomNumber,Dir) :- (RandomNumber <= 0.25 & .nth(0,DirList,Dir)) | (RandomNumber <= 0.5 & .nth(1,DirList,Dir)) | (RandomNumber <= 0.75 & .nth(2,DirList,Dir)) | (.nth(3,DirList,Dir)).
 
/* Initial goals */
state(moveRandom).
!start.
 
/* Plans */
 
+step(X) : (state(requested)&state(movetogoal))|(state(movetoblock)&state(submitted))|(state(movetogoal)&(not(goal(I,J))|not(attached(CX,CY))))<-
.print("error state,skip");
-state(requested);
-state(movetoblock);
-state(movetogoal);
-state(submitted);
!move_random;
+state(moveRandom).
 
 
//to aviod obstacles
+step(X) : obstacle(0,1) | obstacle(0,-1) | obstacle(-1,0) <- move(e); .print("avoiding obstacle").
+step(X) : obstacle(0,1) | obstacle(0,-1) | obstacle(1,0) <- move(w); .print("avoiding obstacle").
+step(X) : obstacle(0,1) | obstacle(-1,0) | obstacle(1,0) <- move(n); .print("avoiding obstacle").
+step(X) : obstacle(0,-1) | obstacle(-1,0) | obstacle(1,0) <- move(s); .print("avoiding obstacle").
 
+step(X) : obstacle(0,1) & obstacle(0,-1) & obstacle(-1,0) <- move(e); .print("avoiding obstacle").
+step(X) : obstacle(0,1) & obstacle(0,-1) & obstacle(1,0) <- move(w); .print("avoiding obstacle").
+step(X) : obstacle(0,1) & obstacle(-1,0) & obstacle(1,0) <- move(n); .print("avoiding obstacle").
+step(X) : obstacle(0,-1) & obstacle(-1,0) & obstacle(1,0) <- move(s); .print("avoiding obstacle").
 
+step(X) : obstacle(0,1) & obstacle(0,-1) <- move(w); .print("avoiding obstacle").
+step(X) : obstacle(0,1) & obstacle(-1,0) <- move(s); .print("avoiding obstacle").
+step(X) : obstacle(0,-1) & obstacle(-1,0) <- move(n); .print("avoiding obstacle").
+step(X) : obstacle(0,1) & obstacle(1,0) <- move(s); .print("avoiding obstacle").
+step(X) : obstacle(0,-1) & obstacle(1,0) <- move(n); .print("avoiding obstacle").
+step(X) : obstacle(-1,0) & obstacle(1,0) <- move(e); .print("avoiding obstacle").
 
+step(X) : obstacle(0,1) <- move(w); .print("avoiding obstacle").
+step(X) : obstacle(0,-1) <- move(s); .print("avoiding obstacle").
+step(X) : obstacle(-1,0) <- move(n); .print("avoiding obstacle").
+step(X) : obstacle(1,0) <- move(e); .print("avoiding obstacle").

//when move to goal,rotate to make submission possible.
+step(X) : state(movetogoal)&attached(1,0)&(not(attached(0,1))) & goal(0,0) <- rotate(cw); .print("rotating for east").
+step(X) : state(movetogoal)&attached(0,-1)&(not(attached(0,1))) & goal(0,0) <- rotate(cw); .print("rotating for north").
+step(X) : state(movetogoal)&attached(-1,0)&(not(attached(0,1))) & goal(0,0) <- rotate(ccw); .print("rotating for west").
 
//after submit back to state(MoveRandom). moving random is a initial state,until the agent find a trigger events,such as dicovering dispenser and goal
 
+step(X) : state(submitted)&goal(0,0) & (not(attached(DX,DY)))<- .print("submitted,move randomly"); +state(moveRandom); -state(movetogoal) ; -state(submitted).
 
//submit the block
+step(X) : state(movetogoal)&goal(0,0) & attached(0,1) & task(TA,_,_,[req(0,1,Blocktype)])<- submit(TA); .print("request submitted"); +state(submitted).
 
//find a goal move to there, if block is attached
+step(X) : (not(state(movetoblock)|state(requested))) & goal(A,B) &attached(BX,BY) & thing(BX,BY,block,Blocktype) & not(A+B<1)& A > 0 & B==0<- move(e); .print("move to goal"); -state(moveRandom);  +state(movetogoal).
+step(X) : (not(state(movetoblock)|state(requested))) & goal(A,B) &attached(BX,BY) & thing(BX,BY,block,Blocktype) & not(A+B<1)& B > 0 & A==0<- move(s); .print("move to goal"); -state(moveRandom);  +state(movetogoal).
+step(X) : (not(state(movetoblock)|state(requested))) & goal(A,B) &attached(BX,BY) & thing(BX,BY,block,Blocktype) & not(A+B<1)& A < 0 & B==0<- move(w); .print("move to goal"); -state(moveRandom);  +state(movetogoal).
+step(X) : (not(state(movetoblock)|state(requested))) & goal(A,B) &attached(BX,BY) & thing(BX,BY,block,Blocktype) & not(A+B<1)& B < 0 & A==0<- move(n); .print("move to goal"); -state(moveRandom);  +state(movetogoal).
 
 //to limit attachment to 2 blocks cause navigation with more than 2 is difficult
+step(X) : state(movetoblock) & attached(0,1) & attached(1,0)|attached(0,1) & attached(0,-1)|attached(0,1)&attached(-1,0)| attached(1,0) & attached(0,-1)| attached(1,0)&attached(-1,0)|attached(0,1) & attached(0,-1) <- +state(moveRandom); -state(movetoblock); ! move_random.

//if agent requested a block,attach, when attach over, move Randomly
 
+step(X) :  state(requested) & thing(0,1,block,Blocktype) & thing(0,1,dispenser,Blocktype) <- attach(s); .print("blocks attached"); -state(requested); +state(moveRandom).
+step(X) :  state(requested) & thing(0,-1,block,Blocktype) & thing(0,-1,dispenser,Blocktype) <- attach(n); .print("blocks attached"); -state(requested); +state(moveRandom).
+step(X) :  state(requested) & thing(-1,0,block,Blocktype) & thing(-1,0,dispenser,Blocktype) <- attach(w); .print("blocks attached"); -state(requested); +state(moveRandom).
+step(X) :  state(requested) & thing(1,0,block,Blocktype) & thing(1,0,dispenser,Blocktype) <- attach(e); .print("blocks attached"); -state(requested); +state(moveRandom).
 
//on finding the dispenser request block
+step(X) :  state(movetoblock) & thing(0,1,dispenser,Dispensertype) <- request(s); .print("requested"); +state(requested); -state(movetoblock).
+step(X) :  state(movetoblock) & thing(0,-1,dispenser,Dispensertype) <- request(n); .print("requested"); +state(requested); -state(movetoblock).
+step(X) :  state(movetoblock) & thing(-1,0,dispenser,Dispensertype) <- request(w); .print("requested"); +state(requested); -state(movetoblock).
+step(X) :  state(movetoblock) & thing(1,0,dispenser,Dispensertype)<- request(e); .print("requested");  +state(requested); -state(movetoblock).
 
// if find dispenser,move towards that
 
+step(X) : not(state(movetogoal)) & (not(attached(-1,0))) & thing(C,D,dispenser,Dispensertype) & C < 1 & D == 0 <- move(w); +state(movetoblock); -state(moveRandom); .print("moving towards dispenser").
+step(X) : not(state(movetogoal)) & (not(attached(1,0))) & thing(C,D,dispenser,Dispensertype) & C > 1 & D == 0 <- move(e); +state(movetoblock); -state(moveRandom); .print("moving towards dispenser").
+step(X) : not(state(movetogoal)) & (not(attached(0,1))) & thing(C,D,dispenser,Dispensertype) & D > 1 & C == 0 <- move(s); +state(movetoblock); -state(moveRandom); .print("moving towards dispenser").
+step(X) : not(state(movetogoal)) & (not(attached(0,-1))) & thing(C,D,dispenser,Dispensertype) & D < 1 & C == 0 <- move(n); +state(movetoblock); -state(moveRandom); .print("moving towards dispenser").
 
//move random  
+step(X) : true<-
.print("move Randomly");
!move_random.
 
//defalut move random plan
+!move_random : .random(RandomNumber) & random_dir([n,s,e,w],RandomNumber,Dir)
<-  move(Dir).