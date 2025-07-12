import Debug "mo:base/Debug";
import Principal "mo:base/Principal";
import Array "mo:base/Array";

actor ORION_Validator {

  type Proposal = {
    id : Nat;
    description : Text;
    creator : Principal;
  };

  type Outcome = {
    proposal_id : Nat;
    result : Text;
  };

  stable var proposals : [Proposal] = [];
  stable var outcomes : [Outcome] = [];

  public func validate(id : Nat, desc : Text) : async () {
    let callerPrincipal = Principal.fromActor(ORION_Validator);
    let newProposal : Proposal = {
      id = id;
      description = desc;
      creator = callerPrincipal;
    };
    proposals := Array.append(proposals, [newProposal]);
    Debug.print("New Proposal Added: " # desc);
  };

  public func addOutcome(proposal_id : Nat, result : Text) : async () {
    let newOutcome : Outcome = { proposal_id = proposal_id; result = result };
    outcomes := Array.append(outcomes, [newOutcome]);
    Debug.print("Outcome Added: " # result);
  };

  public query func getProposals() : async [Proposal] {
    return proposals;
  };

  public query func getOutcomes() : async [Outcome] {
    return outcomes;
  };
};
