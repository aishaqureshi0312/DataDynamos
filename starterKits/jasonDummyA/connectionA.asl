/* Initial beliefs and rules */
random_dir(DirList,RandomNumber,Dir) :- (RandomNumber <= 0.25 & .nth(0,DirList,Dir)) | (RandomNumber <= 0.5 & .nth(1,DirList,Dir)) | (RandomNumber <= 0.75 & .nth(2,DirList,Dir)) | (.nth(3,DirList,Dir)).

/* Initial goals */

!start.

/* Plans */

+step(X) :  thing(0,1,block,Blocktype) <- attach(s).
+step(X) :  thing(0,-1,block,Blocktype) <- attach(n).
+step(X) :  thing(-1,0,block,Blocktype) <- attach(w).
+step(X) :  thing(1,0,block,Blocktype) <- attach(e).

+step(X) :  thing(0,1,dispenser,Dispensertype) <- request(s).
+step(X) :  thing(0,-1,dispenser,Dispensertype) <- request(n).
+step(X) :  thing(-1,0,dispenser,Dispensertype) <- request(w).
+step(X) :  thing(1,0,dispenser,Dispensertype) <- request(e).

+step(X) :  thing(0,1,goal,GoalType) <- move(s).
+step(X) :  thing(0,-1,goal,GoalType) <- move(n).
+step(X) :  thing(-1,0,goal,GoalType) <- move(w).
+step(X) :  thing(1,0,goal,GoalType) <- move(e).

+step(X) :  thing(0,1,goal,GoalType) <- detach(s).
+step(X) :  thing(0,-1,goal,GoalType) <- detach(n).
+step(X) :  thing(-1,0,goal,GoalType) <- detach(w).
+step(X) :  thing(1,0,goal,GoalType) <- detach(e).

/* +!start : true <- 
    .print("hello massim world.").

+step(X) : true <-
    .print("Received step percept.").
    
+actionID(X) : true <- 
    .print("Determining my action");
    !move_random.*/