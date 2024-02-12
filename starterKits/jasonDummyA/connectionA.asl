/* Initial beliefs and rules */
random_dir(DirList,RandomNumber,Dir) :- (RandomNumber <= 0.25 & .nth(0,DirList,Dir)) | (RandomNumber <= 0.5 & .nth(1,DirList,Dir)) | (RandomNumber <= 0.75 & .nth(2,DirList,Dir)) | (.nth(3,DirList,Dir)).


/* Initial goals */
+!move_random : .random(RandomNumber) & random_dir([n,s,e,w],RandomNumber,Dir)
<-  move(Dir).

//This is the code to get the agent to submit the task in the goal

+step(X) : goal(0,0) & attached(0,1) & task(TA,_,_,[req(0,1,Blocktype)])<- submit(TA); .print("request submitted").

//This is tto rotate

+step(X) : attached(1,0) & goal(0,0) <- rotate(cw); .print("rotating for east").
+step(X) : attached(0,-1) & goal(0,0) <- rotate(cw); .print("rotating for north").
+step(X) : attached(-1,0) & goal(0,0) <- rotate(ccw); .print("rotating for west").

//To get the agent with blocks to move towards the goal if they can detect according to the conditions and if not move random

+step(X) : goal(A,B) & attached(BX,BY) & A < 0 & B == 0  <- move(w); .print("move towards goal").
+step(X) : goal(A,B) & attached(BX,BY) & A > 0 & B == 0 <- move(e); .print("move towards goal").
+step(X) : goal(A,B) & attached(BX,BY) & B > 0 & A == 0  <- move(s); .print("move towards goal").
+step(X) : goal(A,B) & attached(BX,BY) & B < 0 & A == 0  <- move(n); .print("move towards goal").

+step(X) : attached(BX,BY) <- !move_random; .print("move random for goal").

//To get the blocks to attach to the blocks also to stop multiple agents attaching to same block.
+step(X) :  thing(0,1,block,Blocktype) & thing(0,1,dispenser,Blocktype) <- attach(s); .print("blocks attached").
+step(X) :  thing(0,-1,block,Blocktype) & thing(0,-1,dispenser,Blocktype) <- attach(n); .print("blocks attached").
+step(X) :  thing(-1,0,block,Blocktype) & thing(-1,0,dispenser,Blocktype) <- attach(w); .print("blocks attached").
+step(X) :  thing(1,0,block,Blocktype) & thing(1,0,dispenser,Blocktype)  <- attach(e); .print("blocks attached").

//To attach multiple blocks
//+step(X) : thing(0,1,block,Blocktype) & attached(0,1) & thing(0,1,dispenser,Blocktype)   <- attach(n); .print("blocks attached two").


//To get the block to request the block
+step(X) :  thing(0,1,dispenser,Dispensertype) <- request(s); .print("requested").
+step(X) :  thing(0,-1,dispenser,Dispensertype) <- request(n); .print("requested").
+step(X) :  thing(-1,0,dispenser,Dispensertype) <- attach(w); .print("requested").
+step(X) :  thing(1,0,dispenser,Dispensertype) <- request(e); .print("requested").



//To get the agents to move moving towards dispenser if they do not have a block attached


+step(X) : thing(C,D,dispenser,Dispensertype) & C < 0 & D == 0 <- move(w); .print("moving towards dispenser").
+step(X) : thing(C,D,dispenser,Dispensertype) & C > 0  & D == 0 <- move(e); .print("moving towards dispenser").
+step(X) : thing(C,D,dispenser,Dispensertype) & D > 0 & C == 0 <- move(s); .print("moving towards dispenser").
+step(X) : thing(C,D,dispenser,Dispensertype) & D < 0 & C == 0 <- move(n); .print("moving towards dispenser").

//Code for obstacles
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

//Code to move randomly
+step(X) <- !move_random; .print("moving randomly").
