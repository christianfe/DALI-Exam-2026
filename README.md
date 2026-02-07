# DALI_City_Rescue

A DALI multi-agent system coordinating a city rescue units designed according to the GAIA methodology guidelines.

Title: **Multi-Agent System for Emergency Management in a City**

## Objective

Design and implement a multi-agent system in the [DALI](https://github.com/AAAI-DISIM-UnivAQ/DALI) language for the detection and coordinated management of emergency events (e.g., fire, gas leak, earthquake) inside a smart building, following a simplified [**GAIA methodology**](https://link.springer.com/content/pdf/10.1023/A:1010071910869.pdf).

---

## Phase 1: Design according to the GAIA Methodology

### 1.1 Roles

| Role           | Main Responsibilities                        |
| -------------- | -------------------------------------------- |
| **Dispatcher** | Manage resorces, receive calls.              |
| **Drone**      | Detects crashes or fires over the city.      |
| **Ambulance**  | Rescue People.                               |
| **FireFighter** | Turn Off fire.                              |

---

### 1.2 Virtual Organization

- **Name**: `CityEmergencyManagementSystem`
- **Goals**:
    - Save people and turn off fires.
    - Ensure prompt and coordinated reaction to emergencies.
    - Emergency control.
- **Roles and Interactions**:
    - `Drone → Dispatcher`: sends alarm messages.
    - `Drone → Dispatcher`: inform about emergency type.
    - `Dispatcher → Drone`: report request about an emergency situation.
    - `Dispatcher → Ambulance`: dispatch to a location.
    - `Dispatcher → FireFighter`: dispatch to a location.

---

### 1.3 Event Table

#### Dispatcher (mainDispatcher)

| Event                                   | Type     | Source      |
| --------------------------------------- | -------- | ----------- |
| `call_emergency(Loc, Type)`             | external | environment |
| `report_emergency(Loc, Type)`           | external | Drone       |
| `im_active(Drone)`                      | external | Drone       |
| `im_recharging(Drone)`                  | external | Drone       |
| `ambulance_ack(dispatch, Loc)`          | external | Ambulance   |
| `fireFighter_ack(dispatch, Loc)`        | external | FireFighter |
| `dispatch_refused(Loc, Reason, Agent)`  | external | Ambulance / FireFighter |
| `ambulance_status(Status, Agent)`       | external | Ambulance   |
| `fireFighter_status(Status, Agent)`     | external | FireFighter |
| `report(emergency_retired, Loc, Agent)` | external | Ambulance / FireFighter |

#### Drone

| Event                      | Type     | Source      |
| -------------------------- | -------- | ----------- |
| `activate`                 | external | Dispatcher  |
| `request_recognition(Loc)` | external | Dispatcher  |
| `spot_fire`                | external | environment |
| `spot_accident`            | external | environment |
| `move_next`                | internal | drone       |
| `battery_check`            | internal | drone       |

#### Ambulance

| Event            | Type     | Source      |
| ---------------- | -------- | ----------- |
| `activate`       | external | Dispatcher  |
| `dispatch(Loc)`  | external | Dispatcher  |
| `move_to_job`    | internal | ambulance   |
| `do_rescue`      | internal | ambulance   |
| `return_base`    | internal | ambulance   |
| `wakeup_check`   | internal | ambulance   |

#### FireFighter

| Event            | Type     | Source      |
| ---------------- | -------- | ----------- |
| `activate`       | external | Dispatcher  |
| `dispatch(Loc)`  | external | Dispatcher  |
| `move_to_job`    | internal | fireunit    |
| `doOperations`   | internal | fireunit    |
| `return_base`    | internal | fireunit    |
| `wakeup_check`   | internal | fireunit    |

--

### 1.4 Action Table

#### Ambulance

| Action             | Description                                |
| ------------------ | ------------------------------------------ |
| `goto(Loc)`        | move to the desired location               |
| `rescue_people`    | rescue people                              |
| `maybe_end_shift`  | probabilistically end shift (go unavailable) |

#### FireFighter (FireRescue)

| Action              | Description                                |
| ------------------- | ------------------------------------------ |
| `goto(Loc)`         | move to the desired location               |
| `extinguish_fire`   | extinguish fire                            |
| `maybe_end_shift`   | probabilistically end shift (go unavailable) |

#### Drone

| Action     | Description                 |
| ---------- | --------------------------- |
| `goto(Loc)`| move to the desired location |
| `recharge` | charge its battery          |


---

### 1.5 Agent Behaviors

- **Dispatcher**: reactive to emergencies; handles the operations.
- **Drone**: reactive to incoming alarms.
- **Ambulance**: reactive to emergency situations; proactive in evaluating the situation.
- **FireFighter**: reactive to emergency situations; proactive in evaluating the situation.

---

### 1.6 Sequence Diagram

Here's a sequence diagram exploiting the agent interaction framework on emergency scenarios.

<br>

<img src="Sequence%20Diagram/DALI_sequence_sm.png" alt="Sequence diagram">





