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
    let caller = Principal.fromActor(ORION_Validator);
    let newProposal : Proposal = {
      id = id;
      description = desc;
      creator = caller;
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

  // ✅ New methods example
  public func deleteProposal(id : Nat) : async () {
    proposals := Array.filter<Proposal>(proposals, func (p) { p.id != id });
    Debug.print("Proposal Deleted: " # debug_show id);
  };

  public func updateProposal(id : Nat, newDesc : Text) : async () {
    proposals := Array.map<Proposal, Proposal>(proposals, func (p) {
      if (p.id == id) {
        { id = p.id; description = newDesc; creator = p.creator }
      } else {
        p
      }
    });
    Debug.print("Proposal Updated: " # debug_show id);
  };

  public query func filterProposalsByCreator(creator : Principal) : async [Proposal] {
    Array.filter<Proposal>(proposals, func (p) { p.creator == creator });
  };
};
