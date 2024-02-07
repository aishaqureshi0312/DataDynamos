/* Initial beliefs and rules */
random_dir(DirList,RandomNumber,Dir) :- (RandomNumber <= 0.25 & .nth(0,DirList,Dir)) | (RandomNumber <= 0.5 & .nth(1,DirList,Dir)) | (RandomNumber <= 0.75 & .nth(2,DirList,Dir)) | (.nth(3,DirList,Dir)).

/* Initial goals */


!start.

/* Plans */

/*step(X) :  thing(0,1,block,goal) <- detach(s).
step(X) :  thing(0,-1,block,goal) <- detach(n).
step(X) :  thing(-1,0,block,goal) <- detach(w).
step(X) :  thing(1,0,block,goal) <- detach(e).*/

/*+step(X) :  thing(0,1,block, Blocktype) <- move_random(true).
+step(X) :  thing(0,-1,block, Blocktype) <- move_random(true).
+step(X) :  thing(-1,0,block, Blocktype) <- move_random(true).
+step(X) :  thing(1,0,block, Blocktype) <- move_random(true).*/

//if(default::lastActionResult(failed_target)){print("failed*");}.

//This is the code to get the agent to submit the task in the goal

//+step(X) :  goal(GX,GY) & attached(true) & task(TA, GX,GY,[req(,,Blocktype)]) <- submit(TA); .print("request submit").

/*+step(X) :  goal(0,1) & attached(true) & task(TA,0,1,[req(,,Blocktype)]) <- submit(TA); .print("request submit").
+step(X) :  goal(0,-1) & attached(true) & task(TA,0,-1,[req(,,Blocktype)]) <- submit(TA); .print("request submit").
+step(X) :  goal(-1,0) & attached(true) & task(TA,-1,0,[req(,,Blocktype)]) <- submit(TA); .print("request submit").
+step(X) :  goal(1,0) & attached(true) & task(TA,1,0,[req(,,Blocktype)]) <- submit(TA); .print("request submit").*/


//submitting the goal
+step(X) :  goal(0,0) & attached(BX,BY) & task(TA, _,_,[req(BX,BY,Blocktype)])<- submit(TA); .print("request submitted").

//rotating the blocks so they are on the south side of the agent 
+step(X) : attached(1,0) & goal(0,0) <- rotate(cw); .print("rotating for east").
+step(X) : attached(0,-1) & goal(0,0) <- rotate(cw); .print("rotating for north").
+step(X) : attached(-1,0) & goal(0,0) <- rotate(ccw); .print("rotating for west").

//looking for goal
+step(X) : attached(BX,BY) <- !move_random.
+step(X) : goal(X,Y) & attached(BX,BY) & Y > 0 & X == 0  <- move(s).
+step(X) : goal(X,Y) & attached(BX,BY) & Y < 0 & X == 0  <- move(n).
+step(X) : goal(X,Y) & attached(BX,BY) & Y == 0 & X > 0  <- move(e).
+step(X) : goal(X,Y) & attached(BX,BY) & Y == 0 & X < 0  <- move(w).

//fail attach if block attached to something else
+step(X) :  thing(block,Blocktype) & attached(BX,BY,entity,Entitytype)  <- detach(Dir); .print("Detach if one agent is there").
+step(X) :  thing(block,Blocktype) & attached(BX,BY,entity,Entitytype) <- detach(Dir); .print("Detach if one agent is there").
+step(X) :  thing(block,Blocktype) & attached(BX,BY,entity,Entitytype) <- detach(Dir); .print("Detach if one agent is there").
+step(X) :  thing(block,Blocktype) & attached(BX,BY,entity,Entitytype)<- detach(Dir); .print("Detach if one agent is there").

//blocks are attached
+step(X) :  thing(0,1,block,Blocktype) & thing(0,-1,dispenser,Blocktype) <- attach(s); .print("blocks attached").
+step(X) :  thing(0,-1,block,Blocktype) & thing(0,-1,dispenser,Blocktype) <- attach(n); .print("blocks attached").
+step(X) :  thing(-1,0,block,Blocktype) & thing(0,-1,dispenser,Blocktype) <- attach(w); .print("blocks attached").
+step(X) :  thing(1,0,block,Blocktype) & thing(0,-1,dispenser,Blocktype) <- attach(e); .print("blocks attached").


//blocks are requested from the dispenser
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
