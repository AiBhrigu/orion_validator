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
  stable var nextId : Nat = 0;

  public func validate(desc : Text) : async () {
    let caller = Principal.fromActor(ORION_Validator);
    let newProposal : Proposal = {
      id = nextId;
      description = desc;
      creator = caller;
    };
    proposals := Array.append(proposals, [newProposal]);
    nextId += 1;
    Debug.print("✅ New Proposal Added: " # desc);
  };

  public func addOutcome(proposal_id : Nat, result : Text) : async () {
    let newOutcome : Outcome = { proposal_id = proposal_id; result = result };
    outcomes := Array.append(outcomes, [newOutcome]);
    Debug.print("✅ Outcome Added: " # result);
  };

  public func deleteProposal(id : Nat) : async () {
    proposals := Array.filter<Proposal>(proposals, func(p) { p.id != id });
    Debug.print("🗑️ Proposal Deleted: " # Nat.toText(id));
  };

  public func updateProposal(id : Nat, newDesc : Text) : async () {
    proposals := Array.map<Proposal, Proposal>(proposals, func(p) {
      if (p.id == id) {
        { id = p.id; description = newDesc; creator = p.creator }
      } else { p }
    });
    Debug.print("✏️ Proposal Updated: " # Nat.toText(id));
  };

  public query func getProposals() : async [Proposal] {
    proposals
  };

  public query func getOutcomes() : async [Outcome] {
    outcomes
  };

  public query func filterProposalsByCreator(principalId : Principal) : async [Proposal] {
    Array.filter<Proposal>(proposals, func(p) { p.creator == principalId })
  };
};
