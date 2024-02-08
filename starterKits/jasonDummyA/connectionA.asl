/* Initial beliefs and rules */
random_dir(DirList,RandomNumber,Dir) :- (RandomNumber <= 0.25 & .nth(0,DirList,Dir)) | (RandomNumber <= 0.5 & .nth(1,DirList,Dir)) | (RandomNumber <= 0.75 & .nth(2,DirList,Dir)) | (.nth(3,DirList,Dir)).

/* Initial goals */


!start.

/* Plans */


//This is the code to get the agent to submit the task in the goal


+step(X) :  goal(0,0) & attached(BX,BY) & task(TA, _,_,[req(BX,BY,Blocktype)])<- submit(TA); .print("request submitted").

+step(X) : attached(1,0) & goal(0,0) <- rotate(cw); .print("rotating for east").
+step(X) : attached(0,-1) & goal(0,0) <- rotate(cw); .print("rotating for north").
+step(X) : attached(-1,0) & goal(0,0) <- rotate(ccw); .print("rotating for west").


+step(X) : attached(BX,BY) <- !move_random.

//9 ==0
+step(X) : goal(X,Y) & attached(BX,BY) & Y == 0 & X > 0 <- move(e). 
+step(X) : goal(X,Y) & attached(BX,BY) & Y > 0 & X == 0 <- move(s). 
+step(X) : goal(X,Y) & attached(BX,BY) & Y == 0 & X < 0 <- move(w). 
+step(X) : goal(X,Y) & attached(BX,BY) & Y < 0 & X == 0 <- move(n).


+step(X) :  thing(0,1,block,Blocktype) & thing(0,1,dispenser,Blocktype) <- attach(s); .print("blocks attached").
+step(X) :  thing(0,-1,block,Blocktype) & thing(0,-1,dispenser,Blocktype) <- attach(n); .print("blocks attached").
+step(X) :  thing(-1,0,block,Blocktype) & thing(-1,0,dispenser,Blocktype) <- attach(w); .print("blocks attached").
+step(X) :  thing(1,0,block,Blocktype) & thing(1,0,dispenser,Blocktype) <- attach(e); .print("blocks attached").



+step(X) :  thing(0,1,dispenser,Dispensertype) <- request(s); .print("requested").
+step(X) :  thing(0,-1,dispenser,Dispensertype) <- request(n); .print("requested").
+step(X) :  thing(-1,0,dispenser,Dispensertype) <- attach(w); .print("requested").
+step(X) :  thing(1,0,dispenser,Dispensertype) <- request(e); .print("requested").

+!start : true <- 
    .print("hello massim world.").

+step(X) : true <-
    .print("Received step percept.").
    
+actionID(X) : true <- 
    .print("Determining my action");
    !move_random.
//  skip.

+!move_random : .random(RandomNumber) & random_dir([n,s,e,w],RandomNumber,Dir)
<-  move(Dir).